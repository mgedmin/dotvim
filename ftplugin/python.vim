" Python files

" Configure external tools (eg flake8) to expect the appropriate Python 2 vs 3
" syntax based on the shebang line
" (let us assume /usr/bin/python is polyglot that supports both)
if getline(1) =~ 'python3' && exists("*Python3")
  call Python3(0)
elseif getline(1) =~ 'python2' && exists("*Python2")
  call Python2(0)
endif


" PEP-8 is good
" (note that vim's runtime ftplugin/python.vim overrides these, so use
" ~/.vim/after/ftplugin/python.vim instead)
setlocal shiftwidth=4 softtabstop=4 expandtab tabstop=8

" dynamic shiftwidth
augroup PythonDynamicShiftWidth
  au CursorMoved,CursorMovedI,WinEnter <buffer>
        \ if python#in_docstring() |
        \   setlocal sw=2 sts=2 |
        \ else |
        \   setlocal sw=4 sts=4 |
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
