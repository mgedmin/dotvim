" Return the directory of the current buffer
function! curdir#get()
    if expand("%") == '' && exists('b:netrw_curdir')
        return b:netrw_curdir
    endif
    let dir = expand("%:~:.:h")
    return dir == '' ? '.' : dir
endf
