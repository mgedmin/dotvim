" Human-readable description of my statusline
let s:statusline = {
      \ 'statusline': '{left} %={right}',
      \ 'left': '{bufnr}:%<{filename}%( {flags}%)%( {tag}%)',
      \ 'right': '{position} {total_lines} {pos}',
      \ 'bufnr': '%n',
      \ 'filename': '%f',
      \ 'flags': '{help}{modified}{ro}{lcd}{errors}',
      \ 'help': '%h',
      \ 'modified': '%m',
      \ 'ro': '%r',
      \ 'position': '%-10.({line}:{col}{maybe_virtual}%)',
      \ 'line': '%l',
      \ 'col': '%c',
      \ 'maybe_virtual': '%V',
      \ 'total_lines': '%4L',
      \ 'pos': '%P',
      \ }
let s:statusline_highlight = {
      \ 'tag': 1,
      \ 'lcd': 2,
      \ 'errors': 'error',
      \ }

fun! s:expand(s)
  return substitute(a:s, '{\([a-z_]\+\)}',
        \ '\=s:eval(submatch(1))', 'g')
endf

fun! s:eval(s)
  let highlight = get(s:statusline_highlight, a:s, "")
  if has_key(s:statusline, a:s)
    let result = s:expand(s:statusline[a:s])
  elseif exists('*mg#statusline_' . a:s)
    let result = '%{mg#statusline_' . a:s . '()}'
  else
    let result = a:s
    let highlight = 'error'
  endif
  if highlight != ''
    let result = s:colorize(result, highlight)
  endif
  return result
endf

fun! s:colorize(s, group_name)
  if a:s == "" || a:group_name == ""
    return a:s
  endif
  if type(a:group_name) == v:t_number
    return "%" . a:group_name . "*" . a:s . "%*"
  else
    return "%#" . a:group_name . "#" . a:s . "%*"
  endif
endf

fun! s:escape(s)
  return substitute(a:s, '%', '%%', 'g')
endf

fun! mg#statusline_lcd()
  return haslocaldir() ? '[lcd]' : ''
endf

fun! mg#statusline_tag()
  let tag = ""
  if tag == "" && exists("*TagInStatusLine")
    let tag = TagInStatusLine()
  endif
  if tag == "" && exists("*CTagInStatusLine")
    let tag = CTagInStatusLine()
  endif
  return tag
endf

fun! mg#statusline_errors()
  let flag = ""
  if flag == "" && exists("*SyntasticStatuslineFlag")
    let flag = SyntasticStatuslineFlag()
  endif
  if flag == "" && exists("*ALEGetStatusLine")
    let total = ale#statusline#Count(bufnr('%')).total
    let flag = total == 0 ? '' : printf('{%d}', total)
  endif
  return flag
endf

fun! mg#statusline()
  return s:eval('statusline')
endf
