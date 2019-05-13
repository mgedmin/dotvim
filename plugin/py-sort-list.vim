" File: py-sort-list.vim
" Author: Marius Gedminas <marius@gedmin.as>
" Version: 0.3
" Last Modified: 2019-05-09
"
" Overview
" --------
" Defines a :SortPythonList command that sorts a list literal under cursor and
" a :ReversePythonList that reverses it.
"
" Also defines a :SortPythonDict command that sorts a dict literal under
" cursor.
"
" All of the commands currently work only for single-line literals.
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
        if not isinstance(values, (list, tuple)):
            raise SyntaxError
    except SyntaxError:
        print("Current line does not contain a valid Python list literal")
        return
    new_line = indent + repr(sorted(values))
    vim.current.line = new_line

def SortPythonDict():
    import vim, ast
    line = vim.current.line
    indent = line[:-len(line.lstrip())]
    try:
        values = ast.literal_eval(line.strip())
        if not isinstance(values, dict):
            raise SyntaxError
    except SyntaxError:
        print("Current line does not contain a valid Python dict literal")
        return
    new_line = indent + repr(dict(sorted(values.items())))
    vim.current.line = new_line

def ReversePythonList():
    import vim, ast
    line = vim.current.line
    indent = line[:-len(line.lstrip())]
    try:
        values = ast.literal_eval(line.strip())
        if not isinstance(values, (list, tuple)):
            raise SyntaxError
    except SyntaxError:
        print("Current line does not contain a valid Python list literal")
        return
    new_line = indent + repr(values[::-1])
    vim.current.line = new_line

END

command! SortPythonList :exec s:python "SortPythonList()"
command! SortPythonDict :exec s:python "SortPythonDict()"
command! ReversePythonList :exec s:python "ReversePythonList()"
