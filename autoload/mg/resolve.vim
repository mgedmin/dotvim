" Intended usage: you're editing /etc/hosts or something and you manually do
" <C-R>=mg#resolve#host('google.com')<CR>
function mg#resolve#host(hostname)
  pyx import socket, vim
  return pyxeval("socket.gethostbyname(vim.eval('a:hostname'))")
endf
