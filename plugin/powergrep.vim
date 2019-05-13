" File: powergrep.vim
" Author: Marius Gedminas <marius@gedmin.as>
" Version: 1.3
" Last Modified: 2019-05-09
"
" Overview
" --------
" Recursive greps at your fingertips:
"
"   :Grepall foo
"
" locates 'foo' in all files in the directory tree, recursively starting from
" the current directory (but ignoring .svn and .bzr subdirs).
"
"   :Grepall docs/ -name '*.txt' -- foo
"
" locates 'foo' in all files named '*.txt' in the docs/ subtree.
"
"   :Gid foo
"
" uses GNU id-utils to very quickly locate all places where an identifier
" 'foo' was used in your source tree.  You must run 'mkid' first
" to build an ID database.
"
" There's also
"
"   :Grep foo
"
" which is almost the same as :grep, but it also opens the results window.
"
" You can postprocess the output of any command (e.g. sort it, or filter it)
" by appending '-- shell command', e.g.
"
"   :Gid foo -- grep 'foo.bar()'
"   :Grepall -- foo -- sort
"
" Syntax
" ------
"
"   :Grep[!] arguments-for-grep [-- filter]
"   :Grepall[!] [arguments-for-find --] arguments-for-grep [-- filter]
"   :Gid[!] arguments-for-gid [-- filter]
"   :Gitgrep[!] arguments-for-git-grep [-- filter]
"   :Ripgrep[!] arguments-for-rg [-- filter]
"
" Requirements
" ------------
"
" :Grepall uses a script ~/bin/grepall [*], if it finds one, or falls back to the
" standard Unix 'find' and 'grep'.
"
" [*] Mine is at https://github.com/mgedmin/scripts/blob/master/grepall
"
" :Grep uses the standard Unix 'grep'.
"
" :Gid uses 'lid' from GNU id-utils, and 'sort'.
"
" :Gitgrep uses 'git grep'.
"
" :Ripgrep uses 'rg'.
"
" Installation
" ------------
" Copy this file into $HOME/.vim/plugin/


function! DoGrep(cmd, query, bang, gfm)
  let l:grepfilter=''
  let l:query=a:query
  if a:query =~ " -- "
    let l:grepfilter='\|'.strpart(a:query, matchend(a:query, " -- "))
    let l:query=strpart(a:query, 0, match(a:query, " -- "))
  endif
  let oldGrepPrg=&grepprg
  let &grepprg=a:cmd.l:grepfilter
  let oldGrepFormat=&grepformat
  let &grepformat=a:gfm
  execute "grep" . a:bang l:query
  let &grepprg=oldGrepPrg
  let &grepformat=oldGrepFormat
  cw
endf

function! Grep(query, bang)
  call DoGrep('grep -nH $*', a:query, a:bang, '%f:%l:%m')
endf

function! Grepall(query, bang)
  let l:findArgs=''
  let l:query=a:query
  if a:query =~ " -- "
    let l:findArgs=strpart(a:query, 0, match(a:query, " -- "))
    let l:query=strpart(a:query, matchend(a:query, " -- "))
  endif
  if filereadable(expand('~/bin/grepall'))
    let l:cmd = 'grepall '.l:findArgs.' -- $*'
  else
    let l:cmd = 'find '.l:findArgs.' -type f \! -path "*/.svn/*" \! -path "*/.bzr/*" -print0\|xargs -0 grep -nH $*'
  endif
  call DoGrep(l:cmd, l:query, a:bang, '%f:%l:%m')
endf

function! Gid(query, bang)
  call DoGrep('lid -Rgrep $* \|sort -t : -k 2,2 -n\|sort -t : -k 1,1 -s', a:query, a:bang, '%f:%l:%m')
endf

function! Grin(query, bang)
  call DoGrep('grin --emacs $*', a:query, a:bang, '%f:%l:%m')
endf

function! Gitgrep(query, bang)
  call DoGrep('git grep -nH $*', a:query, a:bang, '%f:%l:%m')
endf

function! Ripgrep(query, bang)
  call DoGrep('rg --vimgrep $*', a:query, a:bang, '%f:%l:%c:%m')
endf

command! -nargs=+ -complete=tag -bang Grep	call Grep(<q-args>, <q-bang>)
command! -nargs=+ -complete=tag -bang Grepall	call Grepall(<q-args>, <q-bang>)
command! -nargs=+ -complete=tag -bang Gid	call Gid(<q-args>, <q-bang>)
command! -nargs=+ -complete=tag -bang Grin	call Grin(<q-args>, <q-bang>)
command! -nargs=+ -complete=tag -bang Gitgrep	call Gitgrep(<q-args>, <q-bang>)
command! -nargs=+ -complete=tag -bang Ripgrep	call Ripgrep(<q-args>, <q-bang>)
command! -nargs=+ -complete=tag -bang Rg	call Ripgrep(<q-args>, <q-bang>)

" These are Bad Ideas, heh heh heh
cabbrev grepall grepall<C-\>esubstitute(getcmdline(), '^grepall', 'Grepall', '')<cr>
cabbrev gid gid<C-\>esubstitute(getcmdline(), '^gid', 'Gid', '')<cr>
