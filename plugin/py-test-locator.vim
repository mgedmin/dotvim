" File: py-test-locator.vim
" Author: Marius Gedminas <marius@gedmin.as>
" Version: 0.2
" Last Modified: 2007-11-08
"
" Overview
" --------
" Vim script to help find and fix failed Python unit tests.
"
" Probably very specific to the way I work (Zope 3 style unit tests, tags
" file)
"
" Installation
" ------------
" Copy this file and py_test_locator.py to $HOME/.vim/plugin directory
"
" Usage
" -----
" :LocateTest name-of-test
"
" Select the name of the unit test with the mouse, switch to vim, type
" :ClipboardTest
"

if has('python')

    python <<EOF

import sys, os
location = os.path.expanduser('~/.vim/plugin') # XXX
if location not in sys.path:
    sys.path.append(location)

# import or reload py_test_locator.py, because I want :source % to
# notice any changes I made to it
try:
    py_test_locator
except NameError:
    import py_test_locator
else:
    reload(py_test_locator)

EOF

    function! LocateTest(line)
        python py_test_locator.locate_test(vim.eval('a:line'), verbose=int(vim.eval('&verbose')))
    endfunction

else " no Python, fall back

function! LocateTest(line)
    " The line is something like
    "    FAIL: ivija.reportgen.tests.test_pdr.doctest_PDRCoverPage
    " or
    "    Failure in test doctest_PDRCoverPage (ivija.reportgen.tests.test_pdr)
    " The thing to do is to jump to tag doctest_PDRCoverPage.  Also, when
    " the test is
    "    ivija.reportgen.tests.test_report_sections.TestReport.test_render
    " try jumping to TestReport.test_render first, to avoid ambiguities

    let l:m = matchlist(a:line, '\([^: ]\+\):\(\d\+\)')
    if l:m != []
        let fn = l:m[1]
        let row = l:m[2]
        exec "e +" . l:row . " " . l:fn
        return
    endif
    let l:m = matchlist(a:line, '"\([^"]\+\)", line \(\d\+\)')
    if l:m != []
        let fn = l:m[1]
        let row = l:m[2]
        exec "e +" . l:row . " " . l:fn
        return
    endif
    let l:m = matchlist(a:line, 'File \([^"]\+\), line \(\d\+\)')
    if l:m != []
        let fn = l:m[1]
        let row = l:m[2]
        exec "e +" . l:row . " " . l:fn
        return
    endif
    let l:m = matchlist(a:line, '\([-_a-z0-9/.]\+\)')
    if l:m != []
        let fn = l:m[1]
        if filereadable(fn)
            exec "e " . l:fn
            return
        endif
        let fn = 'src/' . fn
        if filereadable(fn)
            exec "e " . l:fn
            return
        endif
    endif
    let l:m = matchlist(a:line, '[a-zA-Z0-9_.]*[.]\(Test[a-zA-Z_0-9]\+[.][a-zA-Z_0-9]\+\)')
    if l:m == []
        let l:m = matchlist(a:line, '[a-zA-Z0-9_.]*[.]\([a-zA-Z_0-9]\+\)')
    endif
    if l:m == []
        let l:m = matchlist(a:line, 'in test \([a-zA-Z_0-9]\+\)')
    endif
    if l:m == []
        let l:m = matchlist(a:line, '\([a-zA-Z_0-9]*test[a-zA-Z_0-9]\+\)')
    endif
    if l:m == []
        let l:m = matchlist(a:line, '^\([a-zA-Z_0-9]\+\)$')
    endif
    if l:m == []
        echo "Don't know how to find" a:line
        return
    endif
    let l:testname = l:m[1]
    if taglist('^'.l:testname.'$') == [] && stridx(l:testname, '.') != -1
        let l:testname = l:testname[stridx(l:testname, '.') + 1:]
    endif
    exec "tjump" l:testname
endfunction

endif

function! LocateTestFromClipboard()
    call LocateTest(substitute(@*, '\f\zs\n\ze\f', '', 'g'))
endfunction

command! -bar -nargs=? LocateTest	call LocateTest(<q-args>)
command! -bar ClipboardTest		call LocateTestFromClipboard()

