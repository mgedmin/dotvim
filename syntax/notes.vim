" for ~/notes/NOTES.txt, which is pseudo-Markdown

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match Heading "^.\+\n=\{3,}$"
syn match Heading "^.\+\n-\{3,}$"
syn match Heading "^.\+\n\~\{3,}$"
syn match Subheading "^#\{1,6}\s.\+$" contains=Link

syn match Comment "^  *#\( .*\)\=$"
syn match Quote "^  *|\( .*\)\=$"

syn match Link "\<TOOL-\d\{1,5}\>"
syn match Link "\<https://\S\+\>/\="

syn match Checkbox /^- \[ \]/hs=s+2
syn match CheckedCheckbox /^- \[[Xx-]\]/hs=s+2

hi def link Heading Title
hi def link Subheading Title
hi def link Checkbox Question
hi def link CheckedCheckbox Comment
hi def link Link Type
hi def link Quote PreProc


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


let b:current_syntax = 'notes'

let &cpo = s:cpo_save
unlet s:cpo_save

