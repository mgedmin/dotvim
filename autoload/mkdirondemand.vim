fun! mkdirondemand#doit()
    let pardir = expand("%:p:h")
    if pardir !~ 'fugitive:' && !isdirectory(pardir)
        echomsg "Creating parent directory " . expand("%:h")
        call mkdir(pardir, "p")
    endif
endf
