" for /root/Changelog

setlocal sw=2 et

" ,q - quote program output
map ,q mq:s/^.*$/\=substitute('    \| '.submatch(0), '\s\+$', '', '')/<bar>noh<cr>`q
