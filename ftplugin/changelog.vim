" for /root/Changelog

setlocal sw=2 et

" ,t - add a timed comment
map <buffer> ,t :put ='    # ['.strftime('%H:%M').'] '<cr>A

" ,q - quote program output
map <buffer> ,q :Quote<cr>

" ,c - comment a block
map <buffer> ,c :Comment<cr>

com! -range Quote <line1>,<line2> call s:quote("| ")
com! -range Comment <line1>,<line2> call s:quote("# ")

fun! s:quote(prefix)
    let saved = exists('*getcurpos') ? getcurpos() : getpos('.')
    let previous = getline(prevnonblank(line('.') - 1))
    let indent = matchstr(previous, '^\s*')
    if previous !~ '^\s*\([#|]\|\.\{3}\)'
        let indent .= "  "
    endif
    let line = getline('.')
    let new_line = indent . a:prefix . s:expandtabs(line)
    call setline('.', substitute(new_line, '\s\+$', '', ''))
    call setpos('.', saved)
endfun

fun! s:expandtabs(s)
    let o = [a:s]
    exec (has('python3') ? 'py3' : 'py') "vim.bindeval('o')[0] = vim.eval('a:s').expandtabs()"
    return o[0]
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
