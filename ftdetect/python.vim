au BufRead,BufNewFile ~/.vim/python-imports.cfg  set filetype=python
au BufRead,BufNewFile *  if getline(1) =~ '^#!/usr/bin/env.* uv run' | set filetype=python | endif
