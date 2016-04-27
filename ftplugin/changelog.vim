" for /root/Changelog

" ,q - quote program output
map ,q mq:s/^.*$/\=substitute('    \| '.submatch(0), '\s\+$', '', '')/<bar>noh<cr>`q
