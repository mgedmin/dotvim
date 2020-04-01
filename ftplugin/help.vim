" Use Enter and Backspace to navigate xrefs in Vim help windows
" From http://vim.wikia.com/wiki/Mapping_to_quickly_browse_help

if exists("b:did_ftplugin")
  finish
endif

" So I can hit Enter on UltiSnips-snippet-options and not end up in :h options
setlocal isk+=-

nnoremap <buffer><cr> <c-]>
nnoremap <buffer><bs> <c-T>

nnoremap <buffer><a-left>  <c-T>
nnoremap <buffer><a-right> :tag<cr>
