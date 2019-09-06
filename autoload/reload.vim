let g:reload#root = "~/.vim/bundle"

fun reload#info(msg)
  echo a:msg
endf

fun reload#plugin(name)
  " This works on my machine!  It's not indented to be a very generic
  " solution!  I write plugins to be reloadable: use fun!, don't use guards, etc.
  let path = g:reload#root . "/" . a:name
  call reload#if_exists(path . "/plugin/*.vim")
  call reload#if_exists(path . "/autoload/*.vim")
  call reload#if_exists(path . "/pythonx/*.py")
endf

fun reload#if_exists(filespec)
  let files = glob(a:filespec, 1, 1)
  if empty(files)
    call reload#info(a:filespec . " does not exist")
  else
    for file in files
      call reload#file(file)
    endfor
  endif
endf

fun reload#file(filename)
  if a:filename =~ "[.]vim$"
    exec "source" a:filename
    call reload#info(a:filename . " reloaded")
  elseif a:filename =~ "[.]py$"
    let module = substitute(a:filename, '^\(.*/\)\=\([^/]\+\)[.]py$', '\2', '')
    if module =~ '^test'
      call reload#info(a:filename . " skipped")
    else
      exec "pyx sys.modules.pop('" . module . "', None)"
      exec "pyx import " module
      call reload#info(a:filename . " reloaded")
    endif
  else
    call reload#info(a:filename . " not recognized")
  endif
endf

fun reload#complete(arg_lead, cmdline, cursor_pos)
  return g:reload#root->expand()->readdir()->join("\n")
endf
