" :Resolve [hostname] -- print IP of hostname and put it into @"
" With no hostname specified on the command line looks for the word under the
" cursor.
fun! Resolve(hostname)
  let hostname = a:hostname != "" ? a:hostname : expand("<cWORD>")
  if l:hostname == ""
    echo "No hostname under cursor"
    return
  endif
  pyx import socket, vim
  try
    let ip = pyxeval("socket.gethostbyname(vim.eval('l:hostname'))")
  catch /.*/
    echo "Failed to resolve" hostname
    return
  endtry
  echo hostname '->' ip
  let @" = ip
  if &clipboard =~ '\<unnamedplus\>'
    let @+ = ip
  endif
  if &clipboard =~ '\<unnamed\>'
    let @* = ip
  endif
endf
command! -bang -nargs=? Resolve  :call Resolve(<q-args>)
