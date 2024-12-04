" Python files

" Configure external tools (eg flake8) to expect the appropriate Python 2 vs 3
" syntax based on the shebang line
" (let us assume /usr/bin/python is polyglot that supports both)
if getline(1) =~ 'python3' && exists("*Python3")
  call Python3(0)
elseif getline(1) =~ 'python2' && exists("*Python2")
  call Python2(0)
endif

if mg#python#project_uses_mypy()
  call mg#python#mypy_on('.tox/mypy/bin/mypy')
endif

if has('patch-8.2.5066')
  setlocal listchars+=leadmultispace:⸱\ \ \  " NB: trailing whitespace
endif

" PEP-8 is good
" (note that vim's runtime ftplugin/python.vim overrides these, so use
" ~/.vim/after/ftplugin/python.vim instead)
setlocal shiftwidth=4 softtabstop=4 expandtab tabstop=8

" dynamic shiftwidth, for editing yaml inside docstrings (OpenAPI
" documentation for HTTP APIs mostly)
augroup PythonDynamicShiftWidth
  au CursorMoved,CursorMovedI,WinEnter <buffer>
        \ if mg#python#in_docstring() && !mg#python#start_of_string() |
        \   setlocal sw=2 sts=2 com+=fb:- |
        \ else |
        \   setlocal sw=4 sts=4 com-=fb:- |
        \ endif
augroup END

" I sometimes use ## as a comment marker for commented-out code,
" to distinguish it from real comments
" (note that vim's runtime ftplugin/python.vim overrides this, so look in
" ~/.vim/after/ftplugin/python.vim instead)
setlocal comments+=b:##

" I work with Pylons projects ('/foo.mako' -> templates/foo.mako) more
" often than I press gf on dotted names (foo.bar -> foo/bar.py)
setlocal includeexpr=substitute(v:fname,'^/','','')

" Use gq to format with black-macchiato
setlocal formatexpr=mg#python#formatexpr()


" I keep mistyping these
abbr <buffer> improt import
abbr <buffer> impot import


" <F5> = add an import statement at the top for name under cursor
" (https://github.com/mgedmin/python-imports.vim)
map  <buffer> <F5>      :ImportName <C-R><C-W><CR>
imap <buffer> <F5>      <C-O><F5>

" <C-F5> = add an import statement here for name under cursor
map  <buffer> <C-F5>    :ImportNameHere <C-R><C-W><CR>
imap <buffer> <C-F5>    <C-O><C-F5>

" <C-F6> = switch between code and test file
" (https://github.com/mgedmin/py-test-switcher.vim)
map  <buffer> <C-F6>    :SwitchCodeAndTest<CR>

" <C-S-F6> = switch between code and test file, creating if necessary
map  <buffer> <C-S-F6>  :SwitchCodeAndTest!<CR>

" <F9> = force syntax re-check (nah, <F2> does that)
"map  <buffer> <F9>     :SyntasticCheck<CR>

" <C-F9> = run test under cursor
" (https://github.com/mgedmin/py-test-runner.vim; integrates with asyncrun.vim)
map  <buffer> <C-F9>    :RunTestUnderCursor<CR>
imap <buffer> <C-F9>    <C-O><C-F9>

" <C-S-F9> = repeat last test run
map  <buffer> <C-S-F9>  :RunLastTestAgain<CR>
imap <buffer> <C-S-F9>  <C-O><C-S-F9>

" <F10> = run pyflakes on this file (obsoleted by syntastic)
"map  <buffer> <F10>    :setlocal makeprg=pyflakes\ %\|make<CR>

" <F11> = toggle coverage highlighting
map  <buffer> <F11>     :ToggleCoverage<CR>

" Smarter ctrl-]
if exists("*pytag#tag_jump_mapping")
  nnoremap <buffer> <expr> <C-]> pytag#tag_jump_mapping() .. 'zv'
endif


" Select part of a string, :Span will tell you where the selection starts and
" ends, relative to the start of a string.
function! s:Span()
  let start = getpos("'<")
  let end = getpos("'>")
  if start[1] != end[1]
      echo 'multiline selection, giving up'
      return
  endif
  let start = start[2]
  let end = end[2]
  let stringstart = searchpos("\\%.l^[^'\"]*\\%<.c['\"]\\zs")
  if stringstart[0] == 0
      echo 'not inside a string, giving up'
      return
  endif
  let stringstart = stringstart[1]
  let span = (start - stringstart) .. ', ' .. (end - stringstart + 1)
  echo span
  let @" = span
  if &clipboard =~ 'unnamed\>'
    let @* = span
  endif
  if &clipboard =~ 'unnamedplus'
    let @+ = span
  endif
endf
command! -range Span :call <SID>Span()
