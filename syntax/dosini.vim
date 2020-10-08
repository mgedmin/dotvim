setlocal foldmethod=expr
setlocal foldexpr=DiffIniSection(v:lnum)

function! DiffIniSection(lineno)
  let line = getline(a:lineno)
  if line =~ '^\['
    return '>1'
  else
    return '='
  endif
endf
