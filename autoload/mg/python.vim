function mg#python#in_docstring()
  let line = line(".")
  " nb: there might be a pythonSpaceError in the syntax stack hiding the
  " pythonString
  let synstack = synstack(line, 1)
  let syn = empty(synstack) ? "" : synIDattr(synstack[0], "name")
  " f-strings can never be docstrings, but I have a bunch of f-strings
  " containing yaml where I want two-space indents too!
  let in_docstring = syn =~# 'python\(Raw\|F\)\=String'
  return in_docstring
endf

" Intended to use as :nnoremap <expr> <C-]> mg#python#tag_jump_mapping()
function mg#python#tag_jump_mapping()
  let line = getline(line("."))
  " :Tag is provided by https://github.com/mgedmin/pytag.vim
  let tag_command = exists(":Tag") ? ":Tag" : ":tag"
  let [modname, startpos, endpos] = matchstrpos(line, '^\(from\|import\)\s\+\zs[a-zA-Z0-9_.]\+')
  if col(".") > startpos && col(".") <= endpos
    " XXX: only :Tag supports full.dotted.names, for :tag we ought to strip
    " everything until the last .
    " XXX: this probably handles relative imports badly
    " XXX: jumping to module.py requires that you build your tags files with
    " ctags --extra=+f
    return tag_command . " " . modname . "\<CR>"
  else
    return "\<C-]>"
  endif
endf
