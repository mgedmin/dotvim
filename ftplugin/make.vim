function! TabOnFirstColumnOnly()
  setlocal expandtab
  if col(".") == 1
    return "\<C-V>\<Tab>"
  else
    return "\<Tab>"
  endif
endf

inoremap <expr> <Tab> TabOnFirstColumnOnly()
