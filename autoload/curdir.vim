" Return the directory of the current buffer
function curdir#get()
    if expand("%") == '' && exists('b:netrw_curdir')
        return b:netrw_curdir
    else
        return expand("%:h")
    endif
endf
