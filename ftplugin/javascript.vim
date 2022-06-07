setlocal includeexpr=v:fname.'.jsx'
setlocal sw=2
if has('patch-8.2.5066')
  setlocal listchars+=leadmultispace:⸱\   " NB: trailing whitespace
endif
