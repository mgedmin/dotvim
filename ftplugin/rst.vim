setlocal includeexpr=substitute(substitute(v:fname,'^/','',''),'$','.rst','')
" wtf default ftplugin sets sw=3 sts=3??? no
setlocal sw=4 sts=4

map <buffer> <F9> :AsyncRun restview %<cr>
map <buffer> <C-F9> :AsyncStop<cr>
