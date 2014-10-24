" Python files

setlocal shiftwidth=4 softtabstop=4 expandtab tabstop=8

" I sometimes use ## as a comment marker for commented-out code,
" to distinguish it from real comments
setlocal comments+=b:##

" I work with Pylons projects ('/foo.mako' -> templates/foo.mako) more
" often than I press gf on dotted names (foo.bar -> foo/bar.py)
setlocal includeexpr=substitute(v:fname,'^/','','')


" <F5> = add an import statement at the top for name under cursor
" (plugin/python-imports.vim)
map  <buffer> <F5>    :ImportName <C-R><C-W><CR>
imap <buffer> <F5>    <C-O><F5>

" <F5> = add an import statement here for name under cursor
" (plugin/python-imports.vim)
map  <buffer> <C-F5>  :ImportNameHere <C-R><C-W><CR>
imap <buffer> <C-F5>  <C-O><C-F5>

" <C-F6> = switch between code and test file
" (plugin/py-test-switcher.vim)
map  <buffer> <C-F6>  :SwitchCodeAndTest<CR>

" <F9> = force syntax re-check
map  <buffer> <F9>    :SyntasticCheck<CR>

" <F10> = run pyflakes on this file (obsoleted by syntastic)
"map  <buffer> <F10>   :setlocal makeprg=pyflakes\ %\|make<CR>


" I keep mistyping this
abbr improt import
