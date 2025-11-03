" Syntax tweaks for Python files
" Adds folding for classes and functions

if &foldmethod != 'diff' && &ft == 'python'
  setlocal foldmethod=expr
endif
if &ft == 'python'
  setlocal foldexpr=PythonFoldLevel(v:lnum)
endif
function! PythonFoldLevel(lineno)
  " very primitive at the moment, but actually works quite well in practice
  let line = getline(a:lineno)
  if line == ''
    if mg#python#in_docstring(a:lineno)
      return '='
    endif
    let line = getline(a:lineno + 1)
    if line =~ '^\(def\|class\)\>'
      return 0
    elseif line =~ '^@'
      return 0
    elseif line =~ '^    \(def\|class\|#\)\>'
      return 1
    else
      let lvl = foldlevel(a:lineno + 1)
      return lvl >= 0 ? lvl : '-1'
    endif
  elseif line =~ '^\(def\|class\)\>'
    return '>1'
  elseif line =~ '^@'   " multiline decorator maybe
    return '>1'
  elseif line =~ '^    \(def\|class\)\>'
    return '>2'
  elseif line =~ '^"""' " module docstring!
    if a:lineno == 2
      return '>1'
    else
      return 1
    endif
  elseif line =~ '^[^] #)]'
    " a non-blank character at the first column stops a fold, except
    " for '#', so that comments in the middle of functions don't break folds,
    " and ')', so that I can have multiline function signatures like
    "
    "     def fn(
    "         arg1,
    "         arg2,
    "     ):
    "         ...
    if mg#python#in_docstring(a:lineno)
      return '='
    else
      return 0
    endif
  elseif line =~ '^# \|^#$' " except when they're proper comments and not commentd-out code (for which I use ##
    return 0
  elseif line =~ '^    [^ )]' " end method folds except watch for black-style signatures
    if mg#python#in_docstring(a:lineno)
      return '='
    else
      return 1
    endif
  else
    let lvl = foldlevel(a:lineno - 1)
    return lvl >= 0 ? lvl : '='
  endif
endf
