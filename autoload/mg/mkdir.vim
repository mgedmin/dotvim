" I should maybe replace this with https://github.com/benizi/vim-automkdir
fun! mg#mkdir#ondemand()
  let pardir = expand("%:p:h")
  if pardir !~ 'fugitive:\|://' && !isdirectory(pardir)
    echomsg "Creating parent directory " . expand("%:h")
    call mkdir(pardir, "p")
  endif
endf

fun! mg#mkdir#if_missing(dir)
  if !isdirectory(a:dir)
    if exists("*mkdir")
      call mkdir(a:dir, "p")
    else
      exec "silent !mkdir -p " . a:dir
    endif
  endif
endf
