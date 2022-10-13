runtime! ftplugin/dosini.vim


fun! CompleteCoverageRc(findstart, base)
  if a:findstart
    let line = getline('.')
    if line =~ '^\['
      return 1
    endif
    return 0
  endif

  let options = {
        \ "run": split("branch command_line concurrency context cover_pylib"
        \              .. " data_file disable_warnings debug dynamic_context"
        \              .. " include omit parallel plugins relative_files"
        \              .. " sigterm source source_pkgs timid"),
        \ "paths": split("source"),
        \ "report": split("exclude_lines fail_under ignore_errors include"
        \                 .. " omit partial_branches precision show_missing"
        \                 .. " skip_covered skip_empty sort"),
        \ "html": split("directory extra_css show_contexts skip_covered"
        \               .. " skip_empty title"),
        \ "xml": split("output package_depth"),
        \ "json": split("output pretty_print show_contexts"),
        \ "lcov": split("output"),
        \ }
  let section = ""
  let line = line('.')
  while line > 0 && getline(line) !~ '^\['
    let line -= 1
  endwhile
  let section = matchstr(getline(line), '^\[\zs\w\+')
  if line == line('.')
    let choices = keys(options)
    let suffix = ']'
  else
    let choices = get(options, section, [])
    let suffix = ' = '
  endif
  let res = []
  for m in choices
    if m =~ '^' .. a:base
      call add(res, m .. suffix)
    endif
  endfor
  return res
endfun

set omnifunc=CompleteCoverageRc
