" Make ^] open the tag in the previous window rather than directly in the
" quickfix window
map <buffer> <expr> <C-]> ":wincmd p <bar> tag ".expand("<cword>")."\<CR>"
