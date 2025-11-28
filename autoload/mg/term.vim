fun! mg#term#find()
  for bufnr in term_list()
    " return the first one found
    return bufnr
  endfor
  return -1
endf

fun! mg#term#switch_or_focus(bufnr)
  for winid in win_findbuf(a:bufnr)
    call win_gotoid(l:winid)
    return
  endfor
  exec a:bufnr 'buf'
endf

fun! mg#term#switch_or_launch()
  let bufnr = mg#term#find()
  if bufnr == -1
    term ++curwin
  else
    call mg#term#switch_or_focus(bufnr)
  endif
endf
