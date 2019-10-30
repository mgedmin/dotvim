" File: web-annotate.vim
" Author: Marius Gedminas <marius@gedmin.as>
" Version: 0.3
" Last Modified: 2019-10-30
"
" Defines a :WebAnnotate command that opens the annotated version of the
" source file you're editing in a web browser.  If you've specified the
" right code browser URL in the config file.
"
" See ~/.vim/web-annotate.cfg for a sample config.
"

command! -bar WebAnnotate call web_annotate#open()
