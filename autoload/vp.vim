function vp#mapping()
  if v:register !~ '["*+]'
    return "p"
  else
    return "p:let @".v:register."=@0|silent! call repeat#set('".getregtype()."p', v:count)\<cr>"
  endif
endf
