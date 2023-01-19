" git diff files should have all the features i use for regular diff files
" but don't override the <CR> mapping for fugitive's own buffers please
if !exists("b:fugitive_type")
  runtime ftplugin/diff.vim
endif
