" Plugin for https://github.com/stsewd/gx-extended.vim
" makes 'gx' on top of TOOL-nnn open the Jira ticket

let g:mg_jira_url = 'https://jira.draeger.com/'

function s:url(ticket)
  return substitute(g:mg_jira_url, '/\?$', '/browse/', '') .. a:ticket
endfunction

function gxext#notes#jira#open(line, mode)
  if a:line =~ '^TOOL-\d\+$'
    call gxext#browse(s:url(a:line))
    return 1
  endif
  return 0
endfunction
