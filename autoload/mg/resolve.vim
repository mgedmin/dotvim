" Intended usage: you're editing /etc/hosts or something and you manually do
" <C-R>=mg#resolve#host('google.com')<CR>
" which is a handful to remember and I'll never actually do it
function mg#resolve#host(hostname)
  pyx import socket, vim
  return pyxeval("socket.gethostbyname(vim.eval('a:hostname'))")
endf
