" Use Enter and Backspace to navigate xrefs in Vim help windows
" From http://www.vim.org/tip_view.php?tip_id=397

if exists("b:did_ftplugin")
  finish
endif

nnoremap <buffer><cr> <c-]>
nnoremap <buffer><bs> <c-T>

nnoremap <buffer><a-left>  <c-T>
nnoremap <buffer><a-right> :tag<cr>
