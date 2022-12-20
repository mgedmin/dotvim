" intended for a mapping like cnoremap <C-K> <C-\>emg#edit_cmdline#delete_to_eol()<CR>
function! mg#edit_cmdline#delete_to_eol()
  return strpart(getcmdline(), 0, getcmdpos()-1)
endf

" intended for a mapping like cnoremap <M-d> <C-\>emg#edit_cmdline#delete_word()<CR>
function! mg#edit_cmdline#delete_word()
  return substitute(getcmdline(), '\%'.getcmdpos().'c[^[:keyword:]]*\k*', '', '')
endf

" intended for a mapping like cnoremap <M-BS> <C-\>emg#edit_cmdline#delete_word()<CR>
function! mg#edit_cmdline#delete_word_backwards()
  let old_len = len(getcmdline())
  let new_line = substitute(getcmdline(), '\k*[^[:keyword:]]*\%'.getcmdpos().'c', '', '')
  let n_deleted = old_len - len(new_line)
  call setcmdpos(getcmdpos() - n_deleted)
  return new_line
endf
