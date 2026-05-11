" for ~/notes/NOTES.txt, which is pseudo-Markdown

syn match Heading "^.\+\n=\+$"
syn match Heading "^.\+\n\~\+$"
syn match Subheading "^#\{1,4}\s.\+$"

hi def link Heading Title
hi def link Subheading Title
