" This is growing to become a refactoring plugin
command! -range -bar SwapAssignment
      \ <line1>,<line2>s/\(^[ \t>.]*\)\(.*\)\( = \)\(.*\)$/\1\4\3\2/ | noh
command! -range -bar SwapTupleMembers
      \ <line1>,<line2>s/\((\)\([^,)]*\)\(,\s*\)\(.*\)\()\)/\1\4\3\2\5/ | noh

fun! s:InlineValue()
  let name = expand('<cword>')
  let pattern = '^\s*' . name . '\s*=\s*'
  let [line, pos] = searchpos(pattern, 'bnW')
  if line != 0
    let value = substitute(getline(line), pattern, '', '')
    exec 'normal ciw' . value . "\<ESC>"
  endif
endf

command! InlineValue    call s:InlineValue()
