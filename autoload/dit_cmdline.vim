" intended for a mapping like cnoremap <C-K> <C-\>edit_cmdline#delete_to_eol()<CR>
function! dit_cmdline#delete_to_eol()
  return strpart(getcmdline(), 0, getcmdpos()-1)
endf
"
" intended for a mapping like cnoremap <M-d> <C-\>edit_cmdline#delete_word()<CR>
function! dit_cmdline#delete_word()
  return substitute(getcmdline(), '\%'.getcmdpos().'c\W*\w*', '', '')
endf
