" I should maybe replace this with https://github.com/benizi/vim-automkdir
fun! mg#mkdir#ondemand()
    let pardir = expand("%:p:h")
    if pardir !~ 'fugitive:' && !isdirectory(pardir)
        echomsg "Creating parent directory " . expand("%:h")
        call mkdir(pardir, "p")
    endif
endf
