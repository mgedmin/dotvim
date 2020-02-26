function python#in_docstring()
  let line = line(".")
  " nb: there might be a pythonSpaceError in the syntax stack hiding the
  " pythonString
  let synstack = synstack(line, 1)
  let syn = empty(synstack) ? "" : synIDattr(synstack[0], "name")
  let in_docstring = syn =~# 'python\(Raw\)\=String'
  return in_docstring
endf
