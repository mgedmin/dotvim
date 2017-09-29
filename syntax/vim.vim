setlocal sw=2

" Custom folding for my vimrc; emulates foldmethod=marker with some tweaks
setlocal foldmethod=expr
setlocal foldexpr=VimFoldLevel(v:lnum)
setlocal foldtext=VimFoldText(v:foldstart,v:foldend,v:folddashes)
function! VimFoldLevel(lineno)
  let line = getline(a:lineno)
  if line =~ '{{{\d'
    let prevline = getline(a:lineno - 1)
    if prevline == '"'
      return matchstr(line, '{{{\zs\d')
    endif
    return '>' . matchstr(line, '{{{\zs\d')
  elseif line =~ '}}}\d'
    return '<' . matchstr(line, '}}}\zs\d')
  elseif line == '"'
    let nextline = getline(a:lineno + 1)
    if nextline =~ '{{{\d'
      return '>' . matchstr(nextline, '{{{\zs\d')
    endif
  elseif line == ''
    let nextline = getline(a:lineno + 1)
    if nextline == '"'
      return 1
    endif
  endif
  let lvl = foldlevel(a:lineno - 1)
  return lvl >= 0 ? lvl : '='
endf
function! VimFoldText(foldstart, foldend, folddashes)
  let size = a:foldend - a:foldstart + 1
  let line = getline(a:foldstart)
  if line =~ '^"\=$'
    let line = getline(a:foldstart + 1)
  endif
  let line = substitute(line, '^ *" \=', '', '')
  let line = substitute(line, '{{{\d\=', '', 'g')
  let line = substitute(line, '\s\+$', '', '')
  return printf('+%s-%3d lines: %s ', a:folddashes, size, line)
endf
