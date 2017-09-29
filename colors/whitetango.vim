"
" White Tango Vim Color Scheme
" =============================
"
" Makes gvim look like vim in a GNOME Terminal that uses the Tango palette:
" http://uwstopia.nl/blog/2006/07/tango-terminal
"
" Inspired by http://blog.micampe.it/articles/2006/10/20/vim-tango-color-scheme
" except that I want my vim windows to be white, not black.
"
" author: Marius Gedminas <marius@gedmin.as>
"
set background=light

hi clear
if exists("syntax_on")
    syntax reset
endif

let colors_name = "whitetango"

"
" Tango colours are:
"
"   number   normal     bold
"
"     0     #2E3436  #555753
"     1     #CC0000  #EF2929
"     2     #4E9A06  #8AE234
"     3     #C4A000  #FCE94F
"     4     #3465A4  #729FCF
"     5     #75507B  #AD7FA8
"     6     #06989A  #34E2E2
"     7     #D3D7CF  #EEEEEC
"
" Except normal text color is black on white rather than #2E3436 on #EEEEEC.
"

hi SpecialKey      guifg=#D3D7CF
hi NonText         guifg=#D3D7CF
hi Directory       guifg=#3465A4
hi ErrorMsg        guifg=#FFFFFF guibg=#CC0000
hi Search          guifg=#000000 guibg=#C4A000
hi MoreMsg         guifg=#4E9A06
hi LineNr          guifg=#C4A000
hi Question        guifg=#4E9A06
hi Title           guifg=#75507B
hi WarningMsg      guifg=#CC0000
hi WildMenu        guifg=#000000 guibg=#C4A000
hi Folded          guifg=#3465A4 guibg=#D3D7CF
hi FoldColumn      guifg=#3465A4 guibg=#D3D7CF
hi DiffAdd                       guibg=#729FCF
hi DiffChange                    guibg=#AD7FA8
hi DiffDelete      guifg=#729FCF guibg=#34E2E2
hi DiffText                      guibg=#EF2929
hi SignColumn      guifg=#3465A4
hi SpellBad        guifg=#CC0000
hi SpellCap        guifg=#3465A4
hi SpellRare                     guibg=#AD7FA8
hi SpellLocal                    guibg=#34E2E2
hi Pmenu                         guibg=#AD7FA8
hi PmenuSel                      guibg=#D3D7CF
hi PmenuSbar                     guibg=#D3D7CF
hi TabLine         guifg=#000000 guibg=#D3D7CF
hi CursorColumn                  guibg=#D3D7CF
hi Comment         guifg=#3465A4
hi Constant        guifg=#CC0000
hi Special         guifg=#75507B
hi Identifier      guifg=#06989A
hi Statement       guifg=#C4A000
hi PreProc         guifg=#75507B
hi Type            guifg=#4E9A06
hi Underlined      guifg=#75507B
hi Error           guifg=#FFFFFF guibg=#CC0000
hi Todo            guifg=#000000 guibg=#C4A000
