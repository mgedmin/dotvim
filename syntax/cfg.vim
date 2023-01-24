setlocal foldmethod=expr
setlocal foldexpr=IniFoldLevel(v:lnum)

function! IniFoldLevel(lineno)
  let line = getline(a:lineno)
  if line =~ '^[[]'
    return '>1'
  else
    return '1'
  endif
endf

