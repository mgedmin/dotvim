" funcs.vim
" $Id$

" Function: ListAllFunctions(ask)
"   Lists all C/C++ functions in current buffer.  If ask is nonzero, inputs
"   a number and jumps to n-th function.
"
" Function: JumpToFunction(n)
"   If n is 0, jumps to v:count-th function
"   If n is nonzero, jumps to n-th function
"
" Authors:
"   Gabriel Zachmann <zach@igd.fhg.de> (quick-n-dirty attempt)
"   Marius Gedminas <marius@gedmin.as> (misc. improvements)

function! Pad(str, len)
    return strpart("                    ", 1, a:len - strlen(a:str)) . a:str
endfunc

function! ListAllFunctions(ask)

    let w = &wrapscan
    set nowrapscan		" don't let // wrap around

    echohl Directory
    echon  "functions in " expand("%") "\n"
    echohl None

    mark z			" remember cursor pos
    1				" go to first line in buffer
    let v:errmsg = ""
    let cnt = 0
    while 1
        silent! /^\([a-zA-Z_].*\)\={\s*$/	" search for next function body start

        if v:errmsg != ""
            break
        endif

        let cnt = cnt + 1
        let b = line(".")
        ?^\s*$?			" go back to line before function declaration
        +			" go to first line of function declaration
        while getline(".") =~ "^//"	" skip comments
	    +
	    if (line(".") > b)	" oops, something is wrong
		exec b
		break
	    endif
        endwhile
	"if (getline(".") =~ "[/][*]") && (b - line(".") > 3)	" skip long comments
	if (getline(".") =~ "^[ \t]*[/][*]")	" skip comments
	    -
	    /\*\//
	    +
	    if (line(".") > b)	" oops, something is wrong
		exec b
		break
	    endif
	endif
        echon  Pad(cnt, 3) ": "
        echohl LineNr
        echon  Pad(line("."), 4)
        echohl None
        echon  " " getline(".") "\n"
        +
        while line(".") <= b && getline(".") != "{"	" print lines
            echon  "     "
            echohl LineNr
            echon  Pad(line("."), 4)
            echohl None
            echon  " " getline(".") "\n"
            +
        endwhile

        +
    endwhile

    " restore cursor pos
    normal! `z
    let &wrapscan = w		" restore option variable

    if a:ask
	let choice = input("Enter nr of choice (<CR> to abort): ")
	if choice
	    call JumpToFunction(choice)
	endif
    endif
endfunction

function! JumpToFunction(nr)

    let w = &wrapscan
    set nowrapscan		" don't let // wrap around

    mark z			" remember cursor pos
    1				" go to first line in buffer
    let v:errmsg = ""
    let cnt = 0
    let nr = a:nr
    if nr < 1
        let nr = v:count
        if nr < 1
            let nr = 1
        endif
    endif

    while 1
        silent! /^\([a-zA-Z_].*\)\={\s*$/	" search for next function body start

        if v:errmsg != ""
            " restore cursor pos
            normal! `z
            break
        endif

        let cnt = cnt + 1
        if cnt == nr
	    let b = line(".")
            ?^\s*$?		" go back to line before function declaration
            +			" go to first line of function declaration
	    if (getline(".") =~ "^[ \t]*[/][*]")	" skip comments
		-
		/\*\//
		+
		if (line(".") >= b)	" oops, something is wrong
		    exec b "-1"
		endif
	    endif
            break
        endif
    endwhile

    let &wrapscan = w		" restore option variable
endfunction

