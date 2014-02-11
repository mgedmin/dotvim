"
" Editing emails formatted by Mutt
"
setlocal expandtab
setlocal textwidth=72
if v:version >= 700
  setlocal spell
endif

" Skip all headers (works nicely with Mutt's edit_headers option)
/^$/
nohlsearch
