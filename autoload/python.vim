function python#in_docstring()
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
