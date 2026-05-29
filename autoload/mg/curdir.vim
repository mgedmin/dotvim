" Return the directory of the current buffer
" with special support for netrw buffers
function! mg#curdir#get()
    if expand("%") == '' && exists('b:netrw_curdir')
        return b:netrw_curdir
    endif
    let dir = expand("%:~:.:h")
    return dir == '' ? '.' : dir
endf
