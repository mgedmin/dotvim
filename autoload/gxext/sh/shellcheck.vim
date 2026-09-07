" Plugin for https://github.com/stsewd/gx-extended.vim
" makes 'gx' on top of SCnnnn open shellcheck wiki pages

function s:url(code)
    return 'https://shellcheck.net/wiki/' .. a:code
endfunction

function gxext#sh#shellcheck#open(line, mode)
  if a:line =~ '^SC\d\d\d\d$'
    call gxext#browse(s:url(a:line))
    return 1
  endif
  return 0
endfunction
