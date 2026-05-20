if hasmapto('puppet#align#AlignHashrockets', 'i')
  " override the => mapping in /usr/share/puppet/vim/after/ftplugin/puppet.vim
  " because I always type =><space> and end up with two spaces after the =>
  inoremap <buffer> <silent> =><Space> =><Esc>:call puppet#align#AlignHashrockets()<CR>A
endif
