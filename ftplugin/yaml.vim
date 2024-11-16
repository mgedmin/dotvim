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
  let span = (start - stringstart) .. '-' .. (end - stringstart + 1)
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
