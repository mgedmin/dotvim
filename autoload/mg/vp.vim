" For use in vnoremap <expr> p mg#vp#mapping(), before Vim made v_P behave
" that way in version 8.2.4881
function mg#vp#mapping()
  if v:register !~ '["*+]'
    return "p"
  else
    " tpope/vim-repeat is needed for call repeat#set(), ideally I should check
    " for its existence but meh, :silent! will make it ignore any errors
    " anyway
    return "p:let @".v:register."=@0|silent! call repeat#set('".getregtype()."p', v:count)\<cr>"
  endif
endf
