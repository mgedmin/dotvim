function resolve#host(hostname)
  pyx import socket, vim
  return pyxeval("socket.gethostbyname(vim.eval('a:hostname'))")
endf
