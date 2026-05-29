# Implement ,q/,c (:Quote/:Comment) and :NewChangelogEntry for /root/Changelog

fun! mg#changelog#quote(prefix)
  let saved = exists('*getcurpos') ? getcurpos() : getpos('.')
  let previous = getline(prevnonblank(line('.') - 1))
  let indent = matchstr(previous, '^\s*')
  if previous !~ '^\s*\([#|]\|\.\{3}\)'
    let indent .= "  "
  endif
  let line = getline('.')
  let new_line = indent . a:prefix . mg#changelog#expandtabs(line)
  call setline('.', substitute(new_line, '\s*\r*$', '', ''))
  call setpos('.', saved)
endfun

fun! mg#changelog#expandtabs(s)
  let o = [a:s]
  pyx vim.bindeval('o')[0] = vim.eval('a:s').expandtabs()
  return o[0]
endfun

fun! mg#changelog#new_changelog_entry()
  let l:user=$SUDO_USER
  if l:user == ''
    let l:user=$USER
  endif
  $
  put =''
  put =strftime('%Y-%m-%d %H:%M %z') . ': '.l:user
  put ='  '
  call feedkeys('a')
endfun
