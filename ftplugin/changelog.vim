" for /root/Changelog

setlocal sw=2 et

" ,q - quote program output
map <buffer> ,q :Quote<cr>

com! -range Quote <line1>,<line2> call s:quote()

fun! s:quote()
    let saved = getcurpos()
    let previous = getline(prevnonblank(line('.') - 1))
    let indent = matchstr(previous, '^\s*')
    if previous !~ '^\s*\([#|]\|\.\{3}\)'
        let indent .= "  "
    endif
    let line = getline('.')
    let new_line = indent . '| ' . line
    call setline('.', substitute(new_line, '\s\+$', '', ''))
    call setpos('.', saved)
endfun

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
