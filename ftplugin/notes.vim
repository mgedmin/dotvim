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

com! -range Quote <line1>,<line2> call mg#changelog#quote("| ")
com! -range Comment <line1>,<line2> call mg#changelog#quote("# ")
