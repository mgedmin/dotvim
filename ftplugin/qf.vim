" Make ^] open the tag in the previous window rather than directly in the
" tiny quickfix window
map <buffer> <expr> <C-]> ":wincmd p <bar> tag ".expand("<cword>")."\<CR>"
"
" Make gf open the file in the previous window rather than directly in the
" tiny quickfix window
map <buffer> <expr> gf expand("<cfile>") != "" ? ":wincmd p <bar> e ".expand("<cfile>")."\<CR>" : ""

" Make gF open the file in the previous window rather than directly in the
" tiny quickfix window, using my source-locator plugin to parse the line
" number and/or function name etc.
map <buffer> gF :pyx source_locator.locate(vim.current.line, command_prefix='wincmd p<bar>')<cr>

" Make <Enter> open the entry as usual, but fall back to gF if it wasn't
" recognized as an error line
map <buffer> <expr> <CR> getqflist()[line('.')-1].valid ? "\<CR>" : "gF"

" Clean up w:quickfix_title produced by vim-fugitive
" see also https://github.com/tpope/vim-fugitive/issues/973
let w:quickfix_title = substitute(w:quickfix_title, '^:hub --git-dir=.* --no-pager grep -n --no-color', ':Ggrep', '')

" Shrink too-high quickfix windows -- fires too soon and breaks AsyncRun :(
"" if winheight(0) > line('$')
""   exe "resize" line('$')
"" endif
