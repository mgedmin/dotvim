" Use Enter and Backspace to navigate xrefs in Vim help windows
" From http://vim.wikia.com/wiki/Mapping_to_quickly_browse_help

if exists("b:did_ftplugin")
  finish
endif

nnoremap <buffer><cr> <c-]>
nnoremap <buffer><bs> <c-T>

nnoremap <buffer><a-left>  <c-T>
nnoremap <buffer><a-right> :tag<cr>
