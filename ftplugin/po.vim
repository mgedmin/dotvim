"
" .po filetype plugin by Marius Gedminas
"
" <F5> or :Unfuzz removes the "fuzzy" label from a translation entry
"
" Bigger scrolloff

setlocal scrolloff=3 spell

fun! s:unfuzz()
  " Maintain cursor position
  let save_cursor = getcurpos()
  " Jump to the end of the paragraph so I can hit <F5> when I'm on or above
  " the #, line, but don't move if I'm already at the end of the paragraph
  norm! k}
  " Find the line with the fuzzy tag, but stop at paragraph boundary
  ?^#,.*\<fuzzy\>\|^$
  " Remove the fuzzy tag -- this can fail
  s/, fuzzy\>//
  " Remove the tag line if fuzzy was the only tag on it
  s/^#\n//e
  " Restore cursor position
  call setpos('.', save_cursor)
endf

com! -bar Unfuzz  call s:unfuzz()

map <buffer> <F5> :Unfuzz<cr>
imap <buffer> <F5> <C-o><F5>
