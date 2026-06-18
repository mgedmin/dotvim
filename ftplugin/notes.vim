" for ~/notes/NOTES.txt, which is pseudo-Markdown

setlocal sw=2 et

map <buffer> <F4> :FindCheckbox<cr>
map <buffer> <S-F4> :FindPrevCheckbox<cr>

" ,q - quote program output
map <buffer> ,q :Quote<cr>

" ,c - comment a block
map <buffer> ,c :Comment<cr>

" ,n - delete ("nuke") all trailing whitespace
map <buffer> ,n :NukeTrailingWhitespace<cr>

" ,p - strip the prompt off
" ,$ - strip the prompt off
map <buffer> ,p :StripPrompt<cr>
map <buffer> ,$ :StripPrompt<cr>

com! -range Quote  call mg#changelog#quote('| ', <line1>, <line2>)
com! -range Comment  call mg#changelog#quote('# ', <line1>, <line2>)
com! -range StripPrompt  call mg#changelog#strip_prompt(<line1>, <line2>)
