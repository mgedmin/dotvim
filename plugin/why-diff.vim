"
" Help me answer a simple question:
" WHY IS VIM DIFFING MY BUFFER AGAINST SOMETHING
"
" (Hint: this plugin doesn't actually help.)
"

function! WhyDiff()
    let l:count = 0
    for l:n in range(1, bufnr('$'))
        if getwinvar(bufwinnr(l:n), '&diff')
            let l:count = l:count + 1
            echo l:n bufname(l:n)
        endif
    endfor
    if &verbose
        echo l:count "buffers have 'diff' mode set"
    endif
endfunction

command! -bar WhyDiff :call WhyDiff()
