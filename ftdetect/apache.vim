" ansible files/ and templates/
au BufRead,BufNewFile */files/apache/*.conf,*/templates/apache/*.conf.j2
      \ set filetype=apache

" autodetect from content?
au BufRead,BufNewFile *.conf,*.conf.j2
      \ if join(getline(1, 10), "") =~ "<VirtualHost" |
      \    setf ft=apache
      \ endif
