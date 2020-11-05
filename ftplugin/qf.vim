setlocal colorcolumn=

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

" Make Ctrl+Shift+F9 re-run the last test
map  <buffer> <C-S-F9>  :RunLastTestAgain<CR>

" Clean up w:quickfix_title produced by vim-fugitive
" see also https://github.com/tpope/vim-fugitive/issues/973
if exists("w:quickfix_title")
  let w:quickfix_title = substitute(w:quickfix_title, '^:hub --git-dir=.* --no-pager grep -n --no-color', ':Ggrep', '')
endif

" Shrink too-high quickfix windows
if winheight(0) > line('$') && get(g:, 'asyncrun_status') != 'running'
  exe "resize" line('$')
endif
