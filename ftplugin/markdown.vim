" npm install -g livedown
if filereadable(expand('~/.local/bin/livedown'))
  map <buffer> <expr> <F9> g:asyncrun_status == "running" ? ":AsyncStop\<CR>" : ":AsyncRun livedown start % --open\<CR>"
  map <buffer> <C-F9> :AsyncStop<cr>
else
  map <buffer> <F9> :InstantMarkdownPreview<CR>
  map <buffer> <C-F9> :InstantMarkdownStop<cr>
endif
