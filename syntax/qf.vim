" Folding rules for py.test output in quickfix window
" (v. useful together with my py-test-runner.vim plugin)
"
" See http://vim.wikia.com/wiki/Fold_quickfix_list_on_directory_or_file_names
" for other ideas

setlocal foldmethod=expr
setlocal foldexpr=PyTestFoldLevel(v:lnum)
function! PyTestFoldLevel(lineno)
  let line = getline(a:lineno)
  if line =~ '^|| =.*=$'
    return '>1'
  elseif line =~ '^|| _.*_$'
    return '>2'
  elseif line =~ '^|| -.*-$'
    return '>3'
  elseif line =~ '^||     '
    return 4
  elseif line =~ '^|| [>E]'
    return 2
  else
    let lvl = foldlevel(a:lineno - 1)
    return lvl >= 0 ? lvl : '='
  endif
endf
