" Python files

" Configure external tools (eg flake8) to expect the appropriate Python 2 vs 3 syntax
if getline(1) =~ 'python3' && exists("*Python3")
  call Python3(0)
elseif getline(1) =~ 'python$' && exists("*Python2")
  call Python2(0)
endif

" PEP-8 is good
setlocal shiftwidth=4 softtabstop=4 expandtab tabstop=8

" I sometimes use ## as a comment marker for commented-out code,
" to distinguish it from real comments
setlocal comments+=b:##

" I work with Pylons projects ('/foo.mako' -> templates/foo.mako) more
" often than I press gf on dotted names (foo.bar -> foo/bar.py)
setlocal includeexpr=substitute(v:fname,'^/','','')


" <F5> = add an import statement at the top for name under cursor
" (plugin/python-imports.vim)
map  <buffer> <F5>      :ImportName <C-R><C-W><CR>
imap <buffer> <F5>      <C-O><F5>

" <C-F5> = add an import statement here for name under cursor
" (plugin/python-imports.vim)
map  <buffer> <C-F5>    :ImportNameHere <C-R><C-W><CR>
imap <buffer> <C-F5>    <C-O><C-F5>

" <C-F6> = switch between code and test file
" (plugin/py-test-switcher.vim)
map  <buffer> <C-F6>    :SwitchCodeAndTest<CR>

" <C-S-F6> = switch between code and test file, creating if necessary
map  <buffer> <C-S-F6>  :SwitchCodeAndTest!<CR>

" <F9> = force syntax re-check (nah, <F2> does that)
"map  <buffer> <F9>     :SyntasticCheck<CR>

" <C-F9> = run test under cursor
map  <buffer> <C-F9>    :RunTestUnderCursor<CR>

" <C-S-F9> = repeat last test run
map  <buffer> <C-S-F9>  :RunLastTestAgain<CR>

" <F10> = run pyflakes on this file (obsoleted by syntastic)
"map  <buffer> <F10>    :setlocal makeprg=pyflakes\ %\|make<CR>


" I keep mistyping this
abbr <buffer> improt import
abbr <buffer> impot import
