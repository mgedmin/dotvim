" Syntax tweaks for diffs/patches

setlocal foldmethod=expr
setlocal foldexpr=DiffFoldLevel(v:lnum)

function! DiffFoldLevel(lineno)
  let line = getline(a:lineno)
  if line =~ '^Index:'
    return '>1'
  elseif line =~ '^RCS file: ' || line =~ '^retrieving revision '
    let lvl = foldlevel(a:lineno - 1)
    return lvl >= 0 ? lvl : '='
  elseif line =~ '^=== ' && getline(a:lineno - 1) =~ '^$\|^[-+ ]'
    return '>1'
  elseif line =~ '^==='
    let lvl = foldlevel(a:lineno - 1)
    return lvl >= 0 ? lvl : '='
  elseif line =~ '^diff'
    return getline(a:lineno - 1) =~ '^retrieving revision ' ? '=' : '>1'
  elseif line =~ '^\(deleted\|new\) file mode \|^index '
    return '='
  elseif line =~ '^index ' && getline(a:lineno - 1) =~ '^diff'
    let lvl = foldlevel(a:lineno - 1)
    return '='
  elseif line =~ '^--- ' && getline(a:lineno - 1) !~ '^diff\|^==='
    let lvl = foldlevel(a:lineno - 1)
    return lvl >= 0 ? lvl : '>1'
  elseif line =~ '^@'
    return '>2'
  elseif line =~ '^[- +\\]'
    let lvl = foldlevel(a:lineno - 1)
    return lvl >= 0 ? lvl : '='
  else
    return '0'
  endif
endf
