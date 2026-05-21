" Plugin for https://github.com/stsewd/gx-extended.vim
" makes 'gx' on top of TOOL-nnn open the Jira ticket

let g:mg_jira_url = 'https://jira.draeger.com/'
let g:mg_jira_projects = ['TOOL']

function s:url(ticket)
  return substitute(g:mg_jira_url, '/\?$', '/browse/', '') .. a:ticket
endfunction

function s:regexp()
  return '^\(' .. join(g:mg_jira_projects, '\|') .. '\)-\d\+$'
endfunction

function gxext#notes#jira#open(line, mode)
  if a:line =~ s:regexp()
    call gxext#browse(s:url(a:line))
    return 1
  endif
  return 0
endfunction
