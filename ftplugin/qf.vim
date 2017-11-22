" Make ^] open the tag in the previous window rather than directly in the
" tiny quickfix window
map <buffer> <expr> <C-]> ":wincmd p <bar> tag ".expand("<cword>")."\<CR>"
"
" Make gf open the file in the previous window rather than directly in the
" tiny quickfix window
map <buffer> <expr> gf expand("<cfile>") != "" ? ":wincmd p <bar> e ".expand("<cfile>")."\<CR>" : ""

" Clean up w:quickfix_title produced by vim-fugitive
" see also https://github.com/tpope/vim-fugitive/issues/973
let w:quickfix_title = substitute(w:quickfix_title, '^:hub --git-dir=.* --no-pager grep -n --no-color', ':Ggrep', '')

" Shrink too-high quickfix windows
if winheight(0) > line('$')
  exe "resize" line('$')
endif
