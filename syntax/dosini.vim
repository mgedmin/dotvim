" don't override folding when this is used as an include in, e.g. markdown
if &ft == 'dosini'
  setlocal foldmethod=expr
  setlocal foldexpr=DiffIniSection(v:lnum)
endif

function! DiffIniSection(lineno)
  let line = getline(a:lineno)
  if line =~ '^\['
    return '>1'
  else
    return '='
  endif
endf
