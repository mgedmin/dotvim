" Human-readable description of my statusline.  Ha!
" This maps component names to definitions, which can use Vim's statusline
" escapes or refer to other components via {name}.
" The main component is called 'statusline'.
" Components can have variations, mentioned in square brackets.
" Invoke them by calling mg#statusline("variant").
let s:statusline = {
      \ 'statusline': '{left} %={right}',
      \ 'left[quickfix]': '{quickfix_tail}{quickfix_title}',
      \ 'left[help]': '{help_prefix} %<{filename}',
      \ 'left': '%<{filename}%( {flags}%)%( {tag}%)',
      \ 'right': '{pos}{position}',
      \ 'left[full]': '{bufnr}:%<{filename}%( {flags}%)%( {tag}%)',
      \ 'right[full]': '{position} {total_lines} {pos}',
      \ 'bufnr': '%n',
      \ 'filename': '%f',
      \ 'help_prefix': ' Help ',
      \ 'quickfix_tail': ' %t ',
      \ 'quickfix_title': "%{exists('w:quickfix_title') ? ' '.w:quickfix_title : ''}",
      \ 'flags': '{help}{modified}{ro}{lcd}{errors}',
      \ 'help': '%h',
      \ 'modified': '%m',
      \ 'modified[terminal]': '',
      \ 'ro': '%r',
      \ 'position': ' %3l:%-2v ',
      \ 'position[full]': '%-10.({line}:{col}{maybe_virtual}%)',
      \ 'line': '%l',
      \ 'col': '%c',
      \ 'maybe_virtual': '%V',
      \ 'total_lines': '%4L',
      \ 'pos': ' %P ',
      \ 'pos[full]': '%P',
      \ }
let s:statusline_highlight = {
      \ 'tag': 1,
      \ 'lcd': 2,
      \ 'errors': 'error',
      \ 'help_prefix': 'mg_statusline_l1',
      \ 'quickfix_tail': 'mg_statusline_l1',
      \ 'pos': 'mg_statusline_r2',
      \ 'position': 'mg_statusline_r1',
      \ }


" colors based on lightline.vim's jellybeans theme
let s:l1_fg = [ '#ffffff', 231 ]
let s:l1_bg = [ '#585858', 240 ]
let s:r1_fg = [ '#606060', 241 ]
let s:r1_bg = [ '#d0d0d0', 252 ]
let s:r2_fg = [ '#bcbcbc', 250 ]
let s:r2_bg = [ '#585858', 240 ]

fun! mg#statusline_highlight_part(part, fg, bg)
  exec 'hi mg_statusline_'.a:part.' ctermfg='.a:fg[1].' ctermbg='.a:bg[1].' guifg='.a:fg[0].' guibg='.a:bg[0]
endf

fun! mg#statusline_highlight()
  call mg#statusline_highlight_part('l1', s:l1_fg, s:l1_bg)
  call mg#statusline_highlight_part('r1', s:r1_fg, s:r1_bg)
  call mg#statusline_highlight_part('r2', s:r2_fg, s:r2_bg)
endf

fun! s:expand(s, variant)
  return substitute(a:s, '{\([a-z_]\+\)}', {m -> s:eval(m[1], a:variant)}, 'g')
endf

fun! s:eval(s, variant)
  let highlight = get(s:statusline_highlight, a:s, "")
  if has_key(s:statusline, a:s . "[" . a:variant . "]")
    let result = s:expand(s:statusline[a:s . "[" . a:variant . "]"], a:variant)
  elseif has_key(s:statusline, a:s)
    let result = s:expand(s:statusline[a:s], a:variant)
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

fun! mg#statusline(...)
  let variant = a:0 >= 1 ? a:1 : ''
  return s:eval('statusline', variant)
endf

call mg#statusline_highlight()
redrawstatus!
