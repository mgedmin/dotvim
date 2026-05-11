" for ~/notes/NOTES.txt, which is pseudo-Markdown

syn match Heading "^.\+\n=\+$"
syn match Heading "^.\+\n-\+$"
syn match Heading "^.\+\n\~\+$"
syn match Subheading "^#\{1,6}\s.\+$"

hi def link Heading Title
hi def link Subheading Title


fun! NoteFolds(lnum)
  let line = getline(a:lnum)
  if line != '' && getline(a:lnum + 1) =~ '^=\+$\|^-\+$\|^\~\+$'
    return '>1'
  elseif line =~ '^#\+\s'
    return '>1'  " or maybe '>2'?  dunno
  endif
  return '='
endf
setlocal foldmethod=expr foldexpr=NoteFolds(v:lnum)
