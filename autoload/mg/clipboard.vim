function mg#clipboard#has_xsel()
  " sudo apt install wl-clipboard
  return executable('xsel')
endf

function mg#clipboard#xsel_copy(reg, type, str)
  call system("xsel -i " .. (a:reg == "+" ? "-b" : "-p"), a:str)
endf

function mg#clipboard#xsel_paste(reg)
  return ('', system("xsel -o " .. (a:reg == "+" ? "-b" : "-p")))
endf

function mg#clipboard#has_wl_copy_paste()
  " sudo apt install wl-clipboard
  return executable('wl-copy') && executable('wl-paste')
endf

" The big problem with these is that wayland clipboard access APIs require
" focus stealing, which causes vim terminal to receive focus lost/gained OSC
" sequences, which are then echoed literally on screen during
" system()/systemlist(), unless I use :silent.
function mg#clipboard#wl_copy(reg, type, str)
  silent call system("wl-copy" .. (a:reg == "+" ? "" : " -p"), a:str)
endf

function mg#clipboard#wl_paste(reg)
  silent return ('', system("wl-paste" .. (a:reg == "+" ? "" : " -p")))
endf
