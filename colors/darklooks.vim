"
" Darklooks Vim Color Scheme
" ==========================
"
" Makes gvim look like vim in a GNOME Terminal that uses the Tango palette:
" and the Gtk+ Darklooks theme.
"
" Inspired by http://blog.micampe.it/articles/2006/10/20/vim-tango-color-scheme
"
" Based on whitetango.vim by Yours Truly.
"
" author: Marius Gedminas <marius@gedmin.as>
"

set background=dark

hi clear
if exists("syntax_on")
    syntax reset
endif

let colors_name = "darklooks"

hi Normal          guifg=#D3D7CF guibg=#2E3436

if &background == "light"
  " Technically, you shouldn't use this, you should always use the dark one,
  " but I'm aiming at an identical look with GNOME Terminal here when you have
  " bg set incorrectly.

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

else

  hi SpecialKey      guifg=#D3D7CF
  hi NonText         guifg=#D3D7CF
  hi Directory       guifg=#34E2E2
  hi ErrorMsg        guifg=#FFFFFF guibg=#CC0000
  hi Search          guifg=#000000 guibg=#C4A000
  hi MoreMsg         guifg=#8AE234
  hi LineNr          guifg=#FCE94F
  hi Question        guifg=#8AE234
  hi Title           guifg=#AD7FA8
  hi WarningMsg      guifg=#EF2929
  hi WildMenu        guifg=#000000 guibg=#C4A000
  hi Folded          guifg=#34E2E2 guibg=#2E3436
  hi FoldColumn      guifg=#34E2E2 guibg=#2E3436
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
  hi PmenuSel                      guibg=#2E3436
  hi PmenuSbar                     guibg=#2E3436
  hi TabLine         guifg=#EEEEEC guibg=#2E3436
  hi CursorColumn                  guibg=#2E3436
  hi Comment         guifg=#34E2E2
  hi Constant        guifg=#AD7FA8
  hi Special         guifg=#EF2929
  hi Identifier      guifg=#34E2E2
  hi Statement       guifg=#FCE94F
  hi PreProc         guifg=#729FCF
  hi Type            guifg=#8AE234
  hi Underlined      guifg=#729FCF
  hi Ignore          guifg=#2E3436
  hi Error           guifg=#FFFFFF guibg=#CC0000
  hi Todo            guifg=#000000 guibg=#C4A000

endif
