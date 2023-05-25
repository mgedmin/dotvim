function mg#python#in_docstring()
  let line = line(".")
  " nb: there might be a pythonSpaceError in the syntax stack hiding the
  " pythonString
  let synstack = synstack(line, 1)
  let syn = empty(synstack) ? "" : synIDattr(synstack[0], "name")
  " f-strings can never be docstrings, but I have a bunch of f-strings
  " containing yaml where I want two-space indents too!
  let in_docstring = syn =~# 'python\(Raw\|F\)\=String'
  " the syntax check was for a string in column 1, but there's one exception:
  " if column 1 itself begins the string, I never want 2-space indents for it
  if getline(line) =~ '^"'
    return 0
  endif
  return in_docstring
endf

" Intended to use as :nnoremap <expr> <C-]> mg#python#tag_jump_mapping()
function mg#python#tag_jump_mapping()
  let line = getline(line("."))
  let [modname, startpos, endpos] = matchstrpos(line, '^\(from\|import\)\s\+\zs[a-zA-Z0-9_.]\+')
  if col(".") > startpos && col(".") <= endpos
    if exists(":Tag")
      " :Tag is provided by https://github.com/mgedmin/pytag.vim
      return ":Tag " . modname . "\<CR>"
    else
      " NB: jumping to module.py requires that you build your tags files with
      " ctags --extra=+f
      let filename = substitute(modname, '^.*[.]', '', '') . '.py'
      return ":tag " . filename . "\<CR>"
    endif
  else
    if exists(":Tag")
      " :Tag is provided by https://github.com/mgedmin/pytag.vim
      return ":Tag " . expand("<cword>") . "\<CR>"
    else
      return "\<C-]>"
    endif
  endif
endf
