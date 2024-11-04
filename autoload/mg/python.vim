pyx << END
import re
import subprocess
import sys

import vim


def black_macchiato(firstline, lastline):
    cmd = vim.eval('get(g:, "black_macchiato_path", "black-macchiato")')
    args = vim.eval('get(g:, "black_macchiato_args", "")')
    lines = vim.current.buffer[firstline-1:lastline]
    result = subprocess.run(
        f'{cmd} {args}',
        shell=True,
        input='\n'.join(lines),
        capture_output=True,
        text=True,
    )
    if result.returncode == 0:
        print('format success')
        new_lines = result.stdout.splitlines()
        if new_lines != lines:
            vim.current.buffer[firstline-1:lastline] = new_lines
        else:
            print(f'no changes made to {len(lines)} lines')
    else:
        msg = result.stderr.strip()
        msg = re.sub(r'^error: cannot format [^:]+: ', '', msg)
        msg = re.sub(r'^Cannot parse: (\d+):', lambda m: f'Cannot parse: {int(m[1]) + firstline}:', msg)
        # for some reason printing to sys.stderr gets suppressed when this is
        # called from inside a formatexpr
        ## print(msg or 'FAILED!', file=sys.stderr)
        # unfortunately vim.command('echohl ErrorMsg') doesn't affect
        # Python print() statements
        print(msg or 'FAILED!')
END

function mg#python#formatexpr()
  let firstline = v:lnum
  let lastline = v:lnum + v:count - 1
  let lines = getline(firstline, lastline)
  if lines->filter({_, s -> s !~ '^\s*#'})->empty()
    " the set of lines that don't start with a # is empty, i.o.w.
    " all lines start with a #
    echo 'all lines start with #, formatting as comments'
    return 1                                " fall back to internal formatting
  endif
  if mg#python#in_docstring(firstline) && mg#python#in_docstring(lastline)
    echo 'formatting as docstring'
    return 1                                " fall back to internal formatting
  endif
  echo 'formatting as python'
  pyx black_macchiato(int(vim.eval('firstline')), int(vim.eval('lastline')))
  return 0
endf

function mg#python#in_docstring(line = 0)
  let line = a:line == 0 ? line(".") : a:line
  " nb: there might be a pythonSpaceError in the syntax stack hiding the
  " pythonString
  let synstack = synstack(line, 1)
  let syn = empty(synstack) ? "" : synIDattr(synstack[0], "name")
  " f-strings can never be docstrings, but I have a bunch of f-strings
  " containing yaml where I want two-space indents too!
  let in_docstring = syn =~# 'python\(Raw\|F\)\=String'
  " the syntax check was for a string in column 1, but there's one exception:
  " if column 1 itself begins the string, I never want 2-space indents for it
  if getline(line) =~ '^"'
    return 0
  endif
  return in_docstring
endf

" Intended to use as :nnoremap <expr> <C-]> mg#python#tag_jump_mapping()
function mg#python#tag_jump_mapping()
  let line = getline(line("."))
  let [modname, startpos, endpos] = matchstrpos(line, '^\(from\|import\)\s\+\zs[a-zA-Z0-9_.]\+')
  if col(".") > startpos && col(".") <= endpos
    if exists(":Tag")
      " :Tag is provided by https://github.com/mgedmin/pytag.vim
      return ":Tag " . modname . "\<CR>"
    else
      " NB: jumping to module.py requires that you build your tags files with
      " ctags --extra=+f
      let filename = substitute(modname, '^.*[.]', '', '') . '.py'
      return ":tag " . filename . "\<CR>"
    endif
  else
    if exists(":Tag")
      " :Tag is provided by https://github.com/mgedmin/pytag.vim
      return ":Tag " . expand("<cword>") . "\<CR>"
    else
      return "\<C-]>"
    endif
  endif
endf

function mg#python#project_uses_mypy()
  if !filereadable('tox.ini')
    return 0
  endif
  for line in readfile('tox.ini', '', 1000)
    if line =~ '\[testenv:mypy\]'
      return 1
    endif
  endfor
  return 0
endf


function mg#python#mypy_on(mypy_executable = '')
  call filter(g:ale_linters.python, 'v:val != "mypy"')
  call add(g:ale_linters.python, "mypy")
  if a:mypy_executable != ''
    let g:ale_python_mypy_executable = substitute(a:mypy_executable, ' .*', '', '')
    let g:ale_python_mypy_options = substitute(a:mypy_executable, '^[^ ]*', '', '')
  elseif filereadable('.tox/mypy/bin/mypy')
    let g:ale_python_mypy_executable = '.tox/mypy/bin/mypy'
    let g:ale_python_mypy_options = ''
  else
    let g:ale_python_mypy_executable = 'mypy'
    let g:ale_python_mypy_options = ''
  endif
  if exists(':ALELint')
    ALELint
  endif
endf

function mg#python#mypy_off()
  call filter(g:ale_linters.python, 'v:val != "mypy"')
  if exists(':ALELint')
    ALELint
  endif
endf
