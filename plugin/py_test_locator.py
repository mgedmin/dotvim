"""
" HACK to make this file source'able by vim as well as importable by Python:
python reload(py_test_locator)
finish
"""
# the second half of py-test-locator.vim
import vim
import os
import re

# Filename search logic will take /path/to/filename and try
#   prefix1/path/to/filename
#   prefix2/path/to/filename
#   prefix1/to/filename
#   prefix2/to/filename
#   prefix1/filename
#   prefix2/filename
# for this reason the first prefix should really be ''.
file_prefixes = ['', 'src', 'packages',
                 'cpanel', 'cpanel/tests/js']
file_suffixes = ['', '.py']

patterns = [
    # svn status output
    re.compile(r'^[A-Z?]      (?P<filename>[^ ]+)$'),
    # py.test encloses the filename in square brackets sometimes,
    re.compile(r'\[(?P<filename>[^: ]+):(?P<lineno>\d+)]'),
    # pdb puts the line number in parentheses,
    re.compile(r'(?P<filename>[^: ]+)[(](?P<lineno>\d+)[)][a-zA-Z_][a-zA-Z_0-9]+[(][)]'),
    # oesjskit tracebacks from firefox
    # E           ()@http://localhost:56166/test/test_Main.js:346
    re.compile(r'http://[a-z0-9.]*:([0-9]+?)/(?P<filename>[^: ]+):(?P<lineno>\d+)]'),
    # standard compiler error message format
    re.compile(r'(?P<filename>[^: ]+):(?P<lineno>\d+)'),
    # tracebacks
    re.compile(r'"(?P<filename>[^: ]+)", line (?P<lineno>\d+)'),
    re.compile(r'File (?P<filename>[^: ]+), line (?P<lineno>\d+)'),
    # filename (lines 123-456)
    re.compile(r'(?P<filename>[^ ]+) [(]lines (?P<lineno>\d+)-\d+[)]'),
    # anything that looks like a unit test name (unittest style)
    re.compile(r'(?P<tag>(?:doc)?test[a-zA-Z0-9_]*) [(](?P<module_class>[a-zA-Z0-9_.]*[.][a-zA-Z_0-9]+)[)]'),
    # anything that looks like a filename
    re.compile(r'(?P<filename>[-_a-zA-Z0-9/.]{3,})'),
    # anything that looks like a package/module
    re.compile(r'(?P<module>[a-zA-Z0-9_.]{3,})'),
    # anything that looks like a unit test name (ivija test runner style)
    re.compile(r'in test (?P<tag>[a-zA-Z_0-9]+)'),
    re.compile(r'(?P<tag>[a-zA-Z0-9_.]*[.]Test[a-zA-Z_0-9]+[.][a-zA-Z_0-9]+)'),
    re.compile(r'(?P<tag>[a-zA-Z0-9_.]*[.][a-zA-Z_0-9]+)'),
    re.compile(r'(?P<tag>[a-zA-Z0-9_]*test[a-zA-Z_0-9]+)'),
    # anything that looks like a tag
    re.compile(r'(?P<tag>[a-zA-Z0-9_.]+)'),
]

def iter_matches(line):
    for pattern in patterns:
        for match in pattern.finditer(line):
            yield match.groupdict()

def locate_file(filename, verbose=False):
    if verbose:
        print 'looking for file %s' % filename
    while filename:
        for prefix in file_prefixes:
            for suffix in file_suffixes:
                new_filename = os.path.join(prefix, filename + suffix)
                if os.path.exists(new_filename):
                    return new_filename
        if '/' not in filename:
            break
        filename = filename.split('/', 1)[1]
        if verbose:
            print '  trying %s' % filename
    return None

def locate_module(module, verbose=False):
    if verbose:
        print 'looking for module %s' % module
    filename = locate_file(module.replace('.', '/') + '.py')
    if not filename:
        filename = locate_file(module.replace('.', '/') + '/__init__.py')
    return filename

def tag_exists(tag_name, verbose=False):
    if verbose:
        print 'looking for tag %s' % tag_name
    try:
        return bool(vim.eval("taglist('^%s$')" % tag_name))
    except vim.error:
        return False

def quote(s):
    return s.replace('\\', '\\\\').replace(' ', '\\ ')

def locate_command(line, verbose=False):
    for match in iter_matches(line):
        filename = match.get('filename')
        lineno = match.get('lineno')
        if filename:
            filename = locate_file(filename, verbose=verbose)
        if not filename:
            module = match.get('module')
            if module:
                filename = locate_module(module, verbose=verbose)
        if filename:
            if lineno:
                return 'e +%s %s' % (lineno, quote(filename))
            else:
                return 'e %s' % quote(filename)
        tag = match.get('tag')
        if tag:
            if '.' in tag and not tag_exists(tag, verbose=verbose):
                tag = tag.rsplit('.', 1)[-1]
            if tag_exists(tag, verbose=verbose):
                return 'tjump %s' % quote(tag)
    return None

def locate_test(line, verbose=False):
    line = line.strip().replace('\\', '/')
    try:
        cmd = locate_command(line, verbose=verbose)
        if cmd:
            print cmd
            try:
                vim.command(cmd)
            except vim.error:
                pass
        else:
            print "Don't know how to find %s" % line
    except KeyboardInterrupt:
        pass


def reload():
    import __builtin__, sys
    __builtin__.reload(sys.modules[__name__])

