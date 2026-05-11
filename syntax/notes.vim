" for ~/notes/NOTES.txt, which is pseudo-Markdown

syn match Heading "^.\+\n=\+$"
syn match Heading "^.\+\n-\+$"
syn match Heading "^.\+\n\~\+$"
syn match Subheading "^#\{1,6}\s.\+$"

syn match Checkbox /^- \[ \]/hs=s+2
syn match CheckedCheckbox /^- \[[Xx-]\]/hs=s+2

hi def link Heading Title
hi def link Subheading Title
hi def link Checkbox Question
hi def link CheckedCheckbox Comment


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
