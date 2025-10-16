" Select part of a string, :Span will tell you where the selection starts and
" ends, relative to the start of a string.
" I used this to prepare test cases for a filename parser, before I realized
" the test cases would be much more readable if I used underlines to define
" spans like this:
"    name: "filename to be parsed"
"    ~~~~: "~~~~~~~~~~~ ^^"
" instead of
"    title_span: 0, 11
"    episode_span: 12, 14
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
