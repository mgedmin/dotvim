" make gf work when on top of the '--- a/path/to/file' line
setlocal includeexpr=substitute(v:fname,'^[ab]/','','')
setlocal path-=**   " (without doing expensive full-tree searches)

fun! s:debug(...)
  if &verbose > 0
    echo call('printf', a:000)
  endif
endf

fun! s:find_location(fn_line_pattern, hunk_pattern, line_sigil)
  let fn_line = search(a:fn_line_pattern, 'bnW')
  if fn_line == 0
    call s:debug("no line matching %s found", a:fn_line_pattern)
    return ['', 0]
  endif
  let filename = getline(fn_line)[4:]
  let filename = substitute(filename, '^[^/]*/', '', '')

  let hunk_line = search('^@@', 'bnW')
  if hunk_line == 0 || hunk_line < fn_line
    call s:debug("no line matching ^@@ found")
    return ['', 0]
  endif
  let hunk_header = getline(hunk_line)
  let hunk_bits = matchlist(hunk_header, a:hunk_pattern)
  if hunk_bits == []
    call s:debug("hunk line %d didn't match %s", hunk_line, a:hunk_pattern)
    return ['', 0]
  endif
  let first_line = str2nr(hunk_bits[1])
  let target_line = first_line - 1
  for lineno in range(hunk_line + 1, line("."))
    let line = getline(lineno)
    if line[0] == ' ' || line[0] == a:line_sigil
      let target_line = target_line + 1
    endif
  endfor
  return [filename, target_line]
endf

fun! s:find_original_location()
  return s:find_location('^---', '^@@ -\(\d\+\),', '-')
endf

fun! s:find_patched_location()
  return s:find_location('^+++', '^@@ -\d\+,\d\+ +\(\d\+\),', '+')
endf

fun! s:find_diff_location()
  if getline(".") =~ "^-"
    return s:find_original_location()
  else
    return s:find_patched_location()
  endif
endf

fun! s:jump(command, location)
  let [filename, target_line] = a:location
  if filename == "" || target_line == 0
    return
  endif
  exec a:command '+'.target_line filename
endf

com! -bar JumpToOriginal :call s:jump('e', s:find_original_location())
com! -bar JumpToPatched  :call s:jump('e', s:find_patched_location())
com! -bar JumpToDiff     :call s:jump('e', s:find_diff_location())
com! -bar SJumpToOriginal :call s:jump('sp', s:find_original_location())
com! -bar SJumpToPatched  :call s:jump('sp', s:find_patched_location())
com! -bar SJumpToDiff     :call s:jump('sp', s:find_diff_location())

map <buffer> <CR> :SJumpToDiff<CR>
