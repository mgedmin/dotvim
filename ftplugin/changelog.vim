" for /root/Changelog

setlocal sw=2 et

" ,q - quote program output
map <buffer> ,q mq:s/^.*$/\=substitute('    \| '.submatch(0), '\s\+$', '', '')/<bar>noh<cr>`q

fun! s:new_changelog_entry()
    let l:user=$SUDO_USER
    if l:user == ''
        let l:user=$USER
    endif
    $
    put =''
    put =strftime('%Y-%m-%d %H:%M %z') . ': '.l:user
    put ='  '
    call feedkeys('a')
endfun

com! NewChangelogEntry call s:new_changelog_entry()
