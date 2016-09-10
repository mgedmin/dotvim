" File: py-sort-list.vim
" Author: Marius Gedminas <marius@gedmin.as>
" Version: 0.1
" Last Modified: 2012-09-07
"
" Overview
" --------
" Defines a :SortPythonList command that sorts a list literal under cursor
"
" Installation
" ------------
" Copy this file to the $HOME/.vim/plugin/ directory
"
" Example
" -------
"
" This is the sort of text this plugin can handle:
"
"     def doctest_somefunc():
"         """Test somefunc
"
"             >>> somefunc(bla bla bla)
"             [5, 1, 6, 9]
"
" Now position your cursor on the line that contains [5, 1, 6, 9] and do
" :SortPythonList<cr>.  The text will change to
"
"             >>> somefunc(bla bla bla)
"             [1, 5, 6, 9]
"

if !has("python") && !has("python3")
    finish
endif

let s:python = has('python3') ? 'python3' : 'python'
exec s:python "<<END"

def SortPythonList():
    import vim, ast
    line = vim.current.line
    indent = line[:-len(line.lstrip())]
    try:
        values = ast.literal_eval(line.strip())
    except SyntaxError:
        print("Current line does not contain a valid Python list literal")
        return
    new_line = indent + repr(sorted(values))
    vim.current.line = new_line

END

command! SortPythonList :exec s:python "SortPythonList()"
