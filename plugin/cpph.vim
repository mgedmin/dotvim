"
" cpph.vim - some VIM macros for editing C/C++ files
" Copyright (c) 2001 Marius Gedminas <mgedmin@delfi.lt>
"
" $Id$
"

" Variable g:cpph_default_ext is used when you are trying to call ToggleHeader
" in a .h file for which there is no corresponding .c/.cc/.cpp.  If it is set,
" it gives the extension of a file to edit, if unset, nothing happens.

" Utility function: switch to buffer containing file or open a new buffer
function! SwitchToFile(name)
    let tmp = bufnr(a:name)
    if tmp == -1
	exe 'edit ' . a:name
    else
	exe 'edit #'. tmp
    endif
endf

" If you're editing a .c, .cc or .cpp file, switch to the appropriate .h
" and vice versa
function! ToggleHeader()
    if expand('%:e') == 'h' || expand('%:e') == 'hxx'
	if filereadable(expand('%:r').'.cc')
	    call SwitchToFile(expand('%:r').'.cc')
	elseif filereadable(expand('%:r').'.cpp')
	    call SwitchToFile(expand('%:r').'.cpp')
	elseif filereadable(expand('%:r').'.c')
	    call SwitchToFile(expand('%:r').'.c')
	elseif filereadable(expand('%:r').'.cxx')
	    call SwitchToFile(expand('%:r').'.cxx')
	elseif exists("g:cpph_default_ext")
	    call SwitchToFile(expand('%:r').g:cpph_default_ext)
	endif
    elseif expand('%:e') == 'c' || expand('%:e') == 'cc' || expand('%:e') == 'cpp'
	call SwitchToFile(expand('%:r').'.h')
    elseif expand('%:e') == 'cxx'
	if filereadable(expand('%:r').'.hxx')
	    call SwitchToFile(expand('%:r').'.hxx')
	else
	  call SwitchToFile(expand('%:r').'.h')
	endif
    endif
endf

" Provide default?  Probably not.
"if !exists("g:cpph_default_ext")
"    let g:cpph_default_ext = ".c"
"endif
