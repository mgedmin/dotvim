" Make ^] open the tag in the previous window rather than directly in the
" tiny quickfix window
map <buffer> <expr> <C-]> ":wincmd p <bar> tag ".expand("<cword>")."\<CR>"
"
" Make gf open the file in the previous window rather than directly in the
" tiny quickfix window
map <buffer> <expr> gf expand("<cfile>") != "" ? ":wincmd p <bar> e ".expand("<cfile>")."\<CR>" : ""
