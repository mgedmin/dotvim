setlocal includeexpr=substitute(substitute(v:fname,'^/','',''),'$','.rst','')
" wtf default ftplugin sets sw=3 sts=3??? no
setlocal sw=4 sts=4

map <buffer> <expr> <F9> g:asyncrun_status == "running" ? ":AsyncStop\<CR>" : ":AsyncRun restview %\<CR>"
map <buffer> <C-F9> :RunTestUnderCursor<CR>
map <buffer> <C-S-F9> :RunLastTestAgain<CR>
