fun! mg#term#find()
  for bufnr in term_list()
    " return the first one found
    return bufnr
  endfor
  return -1
endf

fun! mg#term#has_multiple_splits()
  let n = 0
  for win_id in gettabinfo('.')[0].windows
    if win_gettype(win_id) == "" && getwinvar(win_id, '&buftype') == ""
      let n = n + 1
    endif
  endfor
  return n > 1
endf

fun! mg#term#is_tall()
  let w = winwidth(0)
  return w * 2 <= &columns
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
    if mg#term#has_multiple_splits()
      term ++curwin
    elseif mg#term#is_tall()
      term
    else
      vert term
    endif
  else
    if mg#term#has_multiple_splits()
      call mg#term#switch_or_focus(bufnr)
    elseif mg#term#is_tall()
      split
      call mg#term#switch_or_focus(bufnr)
    else
      vsplit
      call mg#term#switch_or_focus(bufnr)
    endif
  endif
endf
