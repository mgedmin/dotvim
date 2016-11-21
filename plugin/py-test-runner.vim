" File: py-test-runner.vim
" Author: Marius Gedminas <marius@gedmin.as>
" Version: 0.4.2
" Last Modified: 2014-02-11
"
" Overview
" --------
" Vim script to run a unit test you're currently editing.
"
" Probably very specific to the way I work (Zope 3 style unit tests).
"
" Installation
" ------------
" Make sure you have pythonhelper.vim installed.  Then copy this file to
" the $HOME/.vim/plugin directory
"
" This plugin most likely requires vim 7.0 (for the string[idx1:idx2] syntax)
"
" Usage
" -----
" :RunTestUnderCursor -- launches the test runner (configured via
" g:pyTestRunner) with :make
"
" :CopyTestUnderCursor -- copies the command line to run the test into the
" X11 selection
"

" These settings are heavily tailored towards zope.testrunner.
" I've also used it with nose and py.test, after changing the settings as
" appropriate.

if !exists("g:pyVimRunCommand")
    if exists(":Make")
        let g:pyVimRunCommand = "Make"
    else
        let g:pyVimRunCommand = "make"
    endif
endif
if !exists("g:pyTestRunner")
    let g:pyTestRunner = "bin/test"
endif
if !exists("g:pyTestRunnerTestFiltering")
    let g:pyTestRunnerTestFiltering = "-t"
endif
if !exists("g:pyTestRunnerTestFilteringClassAndMethodFormat")
    " would be nice, but unittest formats test IDs by putting the class name
    " in parens
    " let g:pyTestRunnerTestFilteringClassAndMethodFormat = "{class}.{method}"
    " and I don't know how many backslashes I need for correct escaping of
    " same
    " let g:pyTestRunnerTestFilteringClassAndMethodFormat = "{method}\\\\ \\\\({class}\\\\)"
    " so let's just filter by method name
    let g:pyTestRunnerTestFilteringClassAndMethodFormat = "{method}"
endif
if !exists("g:pyTestRunnerTestFilteringBlacklist")
    let g:pyTestRunnerTestFilteringBlacklist = ["__init__", "setUp", "tearDown", "test_suite"]
endif
if !exists("g:pyTestRunnerDirectoryFiltering")
    let g:pyTestRunnerDirectoryFiltering = ""
endif
if !exists("g:pyTestRunnerFilenameFiltering")
    let g:pyTestRunnerFilenameFiltering = ""
endif
if !exists("g:pyTestRunnerPackageFiltering")
    let g:pyTestRunnerPackageFiltering = "-s"
endif
if !exists("g:pyTestRunnerModuleFiltering")
    let g:pyTestRunnerModuleFiltering = "-m"
endif
if !exists("g:pyTestRunnerClipboardExtras")
    ""let g:pyTestRunnerClipboardExtras = "-vc"
    let g:pyTestRunnerClipboardExtras = "-pvc"
endif
if !exists("g:pyTestRunnerClipboardExtrasSuffix")
    ""let g:pyTestRunnerClipboardExtrasSuffix = "|&less -R"
    let g:pyTestRunnerClipboardExtrasSuffix = ""
endif

runtime plugin/pythonhelper.vim
if !exists("*TagInStatusLine")
    finish
endif

function! UseDjangoTestRunner()
    " Assumes you have django-nose, generates command lines of the form
    "   bin/django test <filename>:{class}.{method}
    let g:pyTestRunner = "bin/django test"
    let g:pyTestRunnerTestFilteringClassAndMethodFormat = "{class}.{method}"
    let g:pyTestRunnerTestFiltering = "<NOSPACE>:<NOSPACE>"
    let g:pyTestRunnerPackageFiltering = ""
    let g:pyTestRunnerModuleFiltering = ""
    let g:pyTestRunnerFilenameFiltering = " "
    let g:pyTestRunnerDirectoryFiltering = ""
    let g:pyTestRunnerClipboardExtras = "" " "-v2"
    let g:pyTestRunnerClipboardExtrasSuffix = ""
endfunction

function! UsePyTestTestRunner()
    " Assumes you have py.test, generates command lines of the form
    "   py.test <filename>::{class}.{method}
    let g:pyTestRunner = "py.test"
    let g:pyTestRunnerTestFilteringClassAndMethodFormat = "{class}::{method}"
    let g:pyTestRunnerTestFiltering = "<NOSPACE>::<NOSPACE>"
    let g:pyTestRunnerPackageFiltering = ""
    let g:pyTestRunnerModuleFiltering = ""
    let g:pyTestRunnerFilenameFiltering = " "
    let g:pyTestRunnerDirectoryFiltering = ""
    let g:pyTestRunnerClipboardExtras = ""
    let g:pyTestRunnerClipboardExtrasSuffix = ""
endfunction

function! GetTestUnderCursor()
    let l:test = ""
    if expand("%:e") == "txt" || expand("%:e") == "test"
        let l:test = g:pyTestRunnerTestFiltering . " " . expand("%:t")
    else
        let l:tag = TagInStatusLine()
        if l:tag != ""
            " Older versions of pythonhelper.vim return [fulltagname]
            " Newer versions of pythonhelper.vim return [in fulltagname (type)]
            let l:name = substitute(l:tag[1:-2], '^in ', '', '')
            let l:name = substitute(l:name, ' ([^)]*)$', '', '')
            if l:name =~ '[.]'
                let [l:class, l:name] = split(l:name, '[.]')[:1]
                let l:name = substitute(substitute(g:pyTestRunnerTestFilteringClassAndMethodFormat, '{class}', l:class, 'g'), '{method}', l:name, 'g')
            endif
            if g:pyTestRunnerTestFiltering != ""
                  \ && index(g:pyTestRunnerTestFilteringBlacklist, l:name) == -1
                " we assume here that l:test is ""
                let l:test = g:pyTestRunnerTestFiltering . " " . l:name
            endif
        endif
        if g:pyTestRunnerModuleFiltering != ""
            let l:module = expand("%:t:r")
            if l:module != "__init__"
                let l:test = g:pyTestRunnerModuleFiltering . " " . l:module . " " . l:test
            endif
        endif
    endif
    if g:pyTestRunnerFilenameFiltering != ""
        let l:filename = expand("%")
        let l:test = g:pyTestRunnerFilenameFiltering . " " . l:filename . " " . l:test
    endif
    if l:test != ""
        if g:pyTestRunnerDirectoryFiltering != ""
            let l:directory = expand("%:h")
            let l:test = g:pyTestRunnerDirectoryFiltering . " " . l:directory . " " . l:test
        endif
        if g:pyTestRunnerPackageFiltering != ""
            let pkg = expand("%:p:h")
            let root = pkg
            while strlen(root)
                if !filereadable(root . "/__init__.py")
                    break
                endif
                let root = fnamemodify(root, ":h")
            endwhile
            let pkg = strpart(pkg, strlen(root))
            let pkg = substitute(pkg, ".py$", "", "")
            let pkg = substitute(pkg, ".__init__$", "", "")
            let pkg = substitute(pkg, "^/", "", "g")
            let pkg = substitute(pkg, "/", ".", "g")
            if pkg != ""
                let l:test = g:pyTestRunnerPackageFiltering . " " . l:pkg . " " . l:test
            endif
        endif
    endif
    let l:test = substitute(l:test, ' *<NOSPACE> *', '', 'g')
    let l:test = substitute(l:test, '   *', ' ', 'g')
    let l:test = substitute(l:test, '^  *', '', 'g')
    let l:test = substitute(l:test, '  *$', '', 'g')
    return l:test
endfunction

function! RunTestUnderCursor()
    let l:test = GetTestUnderCursor()
    if l:test != ""
        wall
        if hlexists("StatusLineRunning")
            hi! link StatusLine StatusLineRunning
        endif
        let l:oldmakeprg = &makeprg
        let &makeprg = g:pyTestRunner
        echo g:pyTestRunner l:test
        exec g:pyVimRunCommand l:test
        let &makeprg = l:oldmakeprg
    endif
endfunction

command! RunTestUnderCursor	call RunTestUnderCursor()

function! CopyTestUnderCursor()
    let l:test = GetTestUnderCursor()
    if l:test != ""
        let l:cmd = g:pyTestRunner
        if g:pyTestRunnerClipboardExtras != ""
            let l:cmd = l:cmd . " " . g:pyTestRunnerClipboardExtras
        endif
        let l:cmd = l:cmd . " " . l:test
        if g:pyTestRunnerClipboardExtrasSuffix != ""
            let l:cmd = l:cmd . " " . g:pyTestRunnerClipboardExtrasSuffix
        endif
        echo l:cmd
        let @* = l:cmd
    endif
endfunction

command! CopyTestUnderCursor	call CopyTestUnderCursor()
