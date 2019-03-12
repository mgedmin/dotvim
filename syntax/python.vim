" Syntax tweaks for Python files
" Adds folding for classes and functions

if &foldmethod != 'diff'
  setlocal foldmethod=expr
endif
setlocal foldexpr=PythonFoldLevel(v:lnum)
function! PythonFoldLevel(lineno)
  " very primitive at the moment, but actually works quite well in practice
  let line = getline(a:lineno)
  if line == ''
    let line = getline(a:lineno + 1)
    if line =~ '^\(def\|class\)\>'
      return 0
    elseif line =~ '^    \(def\|class\|#\)\>'
      return 1
    else
      let lvl = foldlevel(a:lineno + 1)
      return lvl >= 0 ? lvl : '-1'
    endif
  elseif line =~ '^\(def\|class\)\>'
    return '>1'
  elseif line =~ '^    \(def\|class\)\>'
    return '>2'
  elseif line =~ '^[^ #]' " # so that comments in the middle of functions don't break folds
    return 0
  elseif line =~ '^# \|^#$' " except when they're proper comments and not commentd-out code (for which I use ##
    return 0
  elseif line =~ '^    [^ ]' " XXX used to be [^ #], why? what did I break by removing #?
    return 1
  else
    let lvl = foldlevel(a:lineno - 1)
    return lvl >= 0 ? lvl : '='
  endif
endf
