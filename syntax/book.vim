" Syntax highlight for plain text and HTML e-books

syn sync fromstart

highlight String ctermfg=darkcyan guifg=darkcyan
syntax clear String
syntax region String start=/"/ end=/"/ skip=/^"/ contains=ALLBUT,String,@NoSpell keepend
syntax region String start=/“/ end=/”/ contains=ALLBUT,String,@NoSpell

highlight Substring ctermfg=green guifg=darkgreen
syntax clear Substring
syntax region Substring start=/‘/ end=/’/ contains=ALLBUT,Substring,String,@NoSpell

syntax region Error start=/\[/ end=/]/

syntax match Title /^\(    \)\=PROLOGUE$/
syntax match Title /^\(    \)\=Prologue$/
syntax match Title /^\(    \)\=CHAPTER [0-9A-Z].*$/
syntax match Title /^\(    \)\=Chapter [0-9A-Z].*$/
syntax match Title /^\(    \)\=EPILOGUE$/
syntax match Title /^\(    \)\=Epilogue$/
syntax match Title /^\(    \)\=PART .*$/
syntax match Title /^    Part .\{0,40}$/
syntax match Title /^Part [^ ]*$/

" nicer spelling
highlight SpellBad cterm=underline ctermfg=red ctermbg=NONE gui=underline guifg=red
highlight SpellCap cterm=underline ctermfg=blue ctermbg=NONE gui=underline guifg=blue

" poor man's HTML syntax
syn match Tag /<[^>]\+>/ contains=@NoSpell
hi Tag ctermfg=gray
syn match Entity /&.\{-};/ contains=@NoSpell
hi Entity ctermfg=darkgreen
syn region Comment start=/<!--/ end=/-->/
hi Comment ctermfg=darkblue
