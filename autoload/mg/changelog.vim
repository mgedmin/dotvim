" Implement ,q/,c/,p (:Quote/:Comment/:StripPrompt) and :NewChangelogEntry
" for /root/Changelog

fun! mg#changelog#quote(prefix, line1, line2)
  let saved = exists('*getcurpos') ? getcurpos() : getpos('.')
  let previous = getline(prevnonblank(a:line1 - 1))
  let indent = matchstr(previous, '^\s*')
  if previous !~ '^\s*\([#|]\|\.\{3}\)'
    let indent .= "  "
  endif
  for i in range(a:line1, a:line2)
    let line = getline(i)
    let new_line = indent . a:prefix . mg#changelog#expandtabs(line)
    call setline(i, substitute(new_line, '\s*\r*$', '', ''))
  endfor
  call setpos('.', saved)
endfun

fun! mg#changelog#is_prompt(line)
  return a:line =~ '^\(\[git:[^\]]*\]\|[^$#]\)*[$#]\s*'
endfun

fun! mg#changelog#strip_prompt_from_line(line1)
  let saved = exists('*getcurpos') ? getcurpos() : getpos('.')
  let previous = getline(prevnonblank(a:line1 - 1))
  let indent = matchstr(previous, '^\s*')
  if previous =~ '^\s*\([#|]\|\.\{3}\)'
    " there's probably a better way to remove the last two characters
    let indent = substitute(indent, '  $', '', '')
  endif
  if indent == ''
    let indent = '  '
  endif
  let line = getline(a:line1)
  let promptless = substitute(line, '^\(\[git:[^\]]*\]\|[^$#]\)\+[$#]\s*', '', '')
  let new_line = indent . promptless
  call setline(a:line1, substitute(new_line, '\s*\r*$', '', ''))
  call setpos('.', saved)
endfun

fun! mg#changelog#strip_prompt(line1, line2)
  call mg#changelog#strip_prompt_from_line(a:line1)
  let start = a:line1
  for i in range(a:line1 + 1, a:line2)
    if mg#changelog#is_prompt(getline(i))
      if start < i - 1
        call mg#changelog#quote("| ", start + 1, i - 1)
      endif
      call mg#changelog#strip_prompt_from_line(i)
      let start = i
    endif
  endfor
  if start < a:line2
    call mg#changelog#quote("| ", start + 1, a:line2)
  endif
endfun

fun! mg#changelog#expandtabs(s)
  let o = [a:s]
  pyx vim.bindeval('o')[0] = vim.eval('a:s').expandtabs()
  return o[0]
endfun

fun! mg#changelog#new_changelog_entry()
  let l:user = $SUDO_USER
  if l:user == ''
    let l:user = $USER
  endif
  $
  put =''
  put =strftime('%Y-%m-%d %H:%M %z') . ': '.l:user
  put ='  '
  call feedkeys('a')
endfun

" Implement Alt-. to insert the last argument of the previous command
" :imap <esc>. <c-r>=mg#changelog#lastarg()<cr>
fun! mg#changelog#lastarg()
  let prev_pos = mg#changelog#prev_pos()
  let curline = line(".")
  let erase = 0
  let default = curline - 1
  if prev_pos != [] && line(".") == prev_pos[0] && col(".") == prev_pos[1] + prev_pos[2]
    let curline = prev_pos[3]
    " intentionally not setting default
    let erase = prev_pos[2]
  endif
  let prevline = mg#changelog#prev_line_with_same_indent(curline, default)
  let word = split(getline(prevline))[-1]
  call mg#changelog#set_prev_pos(line("."), col(".") - erase, len(word), prevline)
  return repeat("\<BS>", erase) .. word
endfun

fun! mg#changelog#prev_line_with_same_indent(curline, default)
  let curindent = indent(a:curline)
  let prevline = a:curline - 1
  while prevline >= 1 && (indent(prevline) != curindent || getline(prevline) == "")
    let prevline -= 1
  endwhile
  return prevline == 0 ? a:default : prevline
endfun

fun! mg#changelog#prev_pos()
  return get(b:, 'lastarg_prev_pos', [])
endfun

fun! mg#changelog#set_prev_pos(line, col, len, prevline)
  let b:lastarg_prev_pos = [a:line, a:col, a:len, a:prevline]
endfun
