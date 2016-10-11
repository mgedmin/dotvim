" File: py-coverage-highlight.vim
" Author: Marius Gedminas <marius@gedmin.as>
" Version: 0.5
" Last Modified: 2012-09-25
"
" Overview
" --------
" Vim script to higlight Python code coverage report results.
"
" Installation
" ------------
" Copy this file to $HOME/.vim/plugin directory
"
" Usage with Ned Batchelder's coverage.py
" ---------------------------------------
" Produce a coverage report with coverage (it's assumed that either it's in
" $PATH, or in $PWD/bin/coverage).  Open a source file.  Use :HiglightCoverage
" to load coverage info, and :HiglightCoverageOff to turn it off.
"
" You can also provide the missing lines directly on the command line,
" eg. :HighlightCoverage NN-NN,NN-NN,NN-NN
"
" Usage with Python's trace.py
" ----------------------------
" Produce a coverage report with Python's trace.py.  Open a source file.
" Load the highlighting with :HiglightCoverage filename/to/coverage.report
" Turn off the highlighting with :HiglightCoverageOff.
"
" Usage with zope.testrunner
" --------------------------
" Produce a coverage report with bin/test --coverage=coverage.  Open a source
" file.  Use :HiglightCoverage to load coverage info, and :HiglightCoverageOff
" to turn it off.
"
" zope.testrunner uses trace.py behind the scenes, and this plugin looks for
" the reports in ./coverage or ./parts/test/working-directory/coverage and
" is able to compute the right filename.

if !has("python") && !has("python3")
    finish
endif

hi NoCoverage ctermbg=gray guibg=#ffcccc
if &t_Co > 8
    hi NoCoverage ctermbg=224
endif
sign define NoCoverage text=>> texthl=NoCoverage linehl=NoCoverage

function! HiglightCoverage(arg)
    sign unplace *
    let python = has('python3') ? 'python3' : 'python'
    exec python "<<END"

import vim, os, subprocess

def filename2module(filename):
    pkg = os.path.splitext(os.path.abspath(filename))[0]
    root = os.path.dirname(pkg)
    while os.path.exists(os.path.join(root, '__init__.py')):
        new_root = os.path.dirname(root)
        if new_root == root:
            break # prevent infinite loops in crazy systems
        else:
            root = new_root
    pkg = pkg[len(root) + len(os.path.sep):].replace('/', '.')
    return pkg


def find_coverage_report(modulename):
    filename = 'coverage/%s.cover' % modulename
    root = os.path.abspath(os.path.curdir)
    if os.path.exists(os.path.join(root, 'parts', 'test', 'working-directory')):
        # zope.testrunner combined with zc.buildout
        root = os.path.join(root, 'parts', 'test', 'working-directory')
    elif os.path.exists(os.path.join(root, 'parts', 'test')):
        # different version of zope.testrunner
        root = os.path.join(root, 'parts', 'test')
    while not os.path.exists(os.path.join(root, filename)):
        new_root = os.path.dirname(root)
        if new_root == root:
            break # prevent infinite loops in crazy systems
        else:
            root = new_root
    return os.path.join(root, filename)


class Signs(object):

    def __init__(self):
        self.signid = 0
        self.bufferid = vim.eval('bufnr("%")')

    def place(self, lineno):
        self.signid += 1
        cmd = "sign place %d line=%d name=NoCoverage buffer=%s" % (self.signid, lineno, self.bufferid)
        vim.command(cmd)


def lazyredraw(fn):
    def wrapped(*args, **kw):
        oldvalue = vim.eval('&lazyredraw')
        try:
            vim.command('set lazyredraw')
            return fn(*args, **kw)
        finally:
            vim.command('let &lazyredraw = %s' % oldvalue)
    return wrapped


@lazyredraw
def parse_cover_file(filename):
    lineno = 0
    signs = Signs()
    for line in file(filename):
        lineno += 1
        if line.startswith('>>>>>>'):
            signs.place(lineno)


def parse_coverage_output(output, filename):
    # Example output without branch coverage:
    # Name                          Stmts   Exec  Cover   Missing
    # -----------------------------------------------------------
    # src/foo/bar/baz/qq/__init__     146    136    93%   170-177, 180-184

    # Example output with branch coverage:
    # Name                          Stmts   Miss Branch BrPart  Cover   Missing
    # -------------------------------------------------------------------------
    # src/foo/bar/baz/qq/__init__     146    136     36      4    93%   170-177, 180-184

    last_line = output.splitlines()[-1]
    filename = os.path.relpath(filename)
    filename_no_ext = os.path.splitext(filename)[0]
    signs = Signs()
    expect_one_of = (
        filename + ' ',
        './' + filename + ' ',
        filename_no_ext + ' ',
        './' + filename_no_ext + ' ',
    )
    if last_line.startswith(expect_one_of):
        # The margin (15) was determined empirically as the smallest value
        # that avoids a 'Press enter to continue...' message
        truncate_to = int(vim.eval('&columns')) - 15
        if len(last_line) <= truncate_to or int(vim.eval('&verbose')) > 0:
            print(last_line)
        else:
            print(last_line[:truncate_to] + '...')
        last_line = last_line[len(filename_no_ext) + 1:].lstrip()
        missing = last_line.rpartition('%')[-1]
        if missing and missing.strip():
            parse_lines(missing, signs)
    else:
        print("Got confused by %s" % repr(last_line))
        print("Expected it to start with %s" % repr(filename_no_ext + ' '))
        print("Full output:")
        print(output)


@lazyredraw
def parse_lines(formatted_list, signs):
    for item in formatted_list.split(', '):
        if '->' in item:
            # skip missed branches
            continue
        if '-' in item:
            lo, hi = item.split('-')
        else:
            lo = hi = item
        lo, hi = int(lo), int(hi)
        for lineno in range(lo, hi+1):
            signs.place(lineno)


def program_in_path(program):
    path = os.environ.get("PATH", os.defpath).split(os.pathsep)
    path = [os.path.join(dir, program) for dir in path]
    path = [True for file in path if os.path.isfile(file)]
    return bool(path)


def find_coverage_script():
    if program_in_path('coverage'):
        # assume it was easy_installed
        return 'coverage'
    # Vagrant means I can't rely on bin/coverage working even if it exists, so
    # prefer a globally-installed one if possible.
    if os.path.exists('bin/coverage'):
        return os.path.abspath('bin/coverage')


def find_coverage_file_for(filename):
    where = os.path.dirname(filename)
    while True:
        if os.path.exists(os.path.join(where, '.coverage')):
            return where
        if os.path.dirname(where) == where:
            return None
        where = os.path.dirname(where)


arg = vim.eval('a:arg')
if arg.endswith('.report'):
    parse_cover_file(arg)
elif arg:
    filename = vim.eval('bufname("%")')
    if '%' not in arg:
        fake_output = filename + ' % ' + arg
    else:
        fake_output = arg
    parse_coverage_output(fake_output, filename)
else:
    filename = vim.eval('bufname("%")')
    coverage_script = find_coverage_script()
    coverage_dir = find_coverage_file_for(filename)
    if coverage_script and coverage_dir:
        relfilename = os.path.relpath(filename, coverage_dir)
        print("Running %s report -m %s" % (os.path.relpath(coverage_script), relfilename))
        output = subprocess.Popen([coverage_script, 'report', '-m', relfilename],
                                  stdout=subprocess.PIPE, cwd=coverage_dir).communicate()[0]
        if not isinstance(output, str):
            output = output.decode('UTF-8', 'replace')
        parse_coverage_output(output, relfilename)
    else:
        modulename = filename2module(filename)
        filename = find_coverage_report(modulename)
        if os.path.exists(filename):
            print("Using %s" % filename)
            parse_cover_file(filename)
        else:
            sys.stderr.write("Neither .coverage nor %s found\n" % filename)
            sys.stderr.flush()

END
endf

command! -nargs=* -complete=file -bar HiglightCoverage	call HiglightCoverage(<q-args>)
command!                         -bar HiglightCoverageOff	sign unplace *
