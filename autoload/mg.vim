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
      \ 'left': '%<{filename}%( {flags}%)',
      \ 'right': '{tag}{pos}{position}',
      \ 'left[full]': '{bufnr}:%<{filename}%( {flags}%)%( {tag}%)',
      \ 'right[full]': '{position} {total_lines} {pos}',
      \ 'tag': '%{mg#statusline_tag(" %s ")}',
      \ 'tag[full]': '%{mg#statusline_tag()}',
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
      \ 'errors': '%{mg#statusline_errors(" %d ")}',
      \ 'errors[full]': '%{mg#statusline_errors()}',
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
      \ 'tag': 'mg_statusline_tag',
      \ 'lcd': 2,
      \ 'errors': 'error',
      \ 'help_prefix': 'mg_statusline_l1',
      \ 'quickfix_tail': 'mg_statusline_l1',
      \ 'pos': 'mg_statusline_r2',
      \ 'position': 'mg_statusline_r1',
      \ }

let s:tabline = {
      \ 'tabline': '{left}{middle}{right}',
      \ 'left': '{tabs}',
      \ 'middle': '%T%=',
      \ 'right': '{close}',
      \ 'active_tab': '{tab}',
      \ 'inactive_tab': '{tab}',
      \ 'tab': '%{nr}T {nr} {name}{modified} ',
      \ 'modified_sign': ' +',
      \ 'close': '%999X X ',
      \ }
let s:tabline_highlight = {
      \ 'active_tab': 'mg_tabline_active',
      \ 'inactive_tab': 'mg_tabline_inactive',
      \ 'middle': 'mg_tabline_middle',
      \ 'close': 'mg_tabline_close',
      \ }

" colors based on lightline.vim's powerline theme
let s:l1_fg = [ '#ffffff', 231 ]
let s:l1_bg = [ '#585858', 240 ]
let s:r1_fg = [ '#606060', 241 ]
let s:r1_bg = [ '#d0d0d0', 252 ]
let s:r2_fg = [ '#bcbcbc', 250 ]
let s:r2_bg = [ '#585858', 240 ]
let s:tag_fg = [ '#d0d0d0', 252 ]
let s:tag_bg = [ '#008700', 28 ]
" and for tabline
let s:active_fg = [ '#bcbcbc', 250 ]
let s:active_bg = [ '#262626', 235 ]
let s:inactive_fg = [ '#bcbcbc', 250 ]
let s:inactive_bg = [ '#585858', 240 ]
let s:middle_fg = [ '#303030', 236 ]
let s:middle_bg = [ '#9e9e9e', 247 ]
let s:close_fg = [ '#bcbcbc', 250 ]
let s:close_bg = [ '#4e4e4e', 239 ]

fun! mg#statusline_highlight_part(part, fg, bg)
  exec 'hi mg_statusline_'.a:part.' ctermfg='.a:fg[1].' ctermbg='.a:bg[1].' guifg='.a:fg[0].' guibg='.a:bg[0]
endf

fun! mg#statusline_highlight()
  call mg#statusline_highlight_part('l1', s:l1_fg, s:l1_bg)
  call mg#statusline_highlight_part('r1', s:r1_fg, s:r1_bg)
  call mg#statusline_highlight_part('r2', s:r2_fg, s:r2_bg)
  call mg#statusline_highlight_part('tag', s:tag_fg, s:tag_bg)
endf

fun! mg#tabline_highlight_part(part, fg, bg)
  exec 'hi mg_tabline_'.a:part.' ctermfg='.a:fg[1].' ctermbg='.a:bg[1].' guifg='.a:fg[0].' guibg='.a:bg[0]
endf

fun! mg#tabline_highlight()
  call mg#tabline_highlight_part('active', s:active_fg, s:active_bg)
  call mg#tabline_highlight_part('inactive', s:inactive_fg, s:inactive_bg)
  call mg#tabline_highlight_part('middle', s:middle_fg, s:middle_bg)
  call mg#tabline_highlight_part('close', s:close_fg, s:close_bg)
endf


fun! s:expand(s, options)
  return substitute(a:s, '{\([a-z_]\+\)}', {m -> s:eval(m[1], a:options)}, 'g')
endf

fun! s:eval(s, options)
  let variant = get(a:options, "variant", "")
  let component_map = get(a:options, "components", s:statusline)
  let highlight_map = get(a:options, "highlight", s:statusline_highlight)
  let dyn_prefix = get(a:options, "prefix", "statusline")
  let highlight = get(highlight_map, a:s, "")
  if has_key(component_map, a:s . "[" . variant . "]")
    let result = s:expand(component_map[a:s . "[" . variant . "]"], a:options)
  elseif has_key(component_map, a:s)
    let result = s:expand(component_map[a:s], a:options)
  elseif exists('*mg#' . dyn_prefix . '_' . a:s)
    let result = '%{mg#' . dyn_prefix . '_' . a:s . '()}'
  elseif exists('*mg#' . dyn_prefix . '_eval_' . a:s)
    let result = call('mg#' . dyn_prefix . '_eval_' . a:s, [a:options])
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

fun! s:shortpath(path)
  return substitute(a:path, '\([.]\=[^/]\)[^/]\+/', '\1/', 'g')
endf

fun! mg#statusline_lcd()
  return haslocaldir() ? '[lcd]' : ''
endf

fun! mg#statusline_tag(...)
  let format = a:0 >= 1 ? a:1 : '[%s]'
  let tag = ""
  if tag == "" && exists("*TagInStatusLine")
    let tag = TagInStatusLine()
  endif
  if tag == "" && exists("*CTagInStatusLine")
    let tag = CTagInStatusLine()
  endif
  if tag != ""
    let tag = printf(format, tag[1:-2])
  endif
  return tag
endf

fun! mg#statusline_errors(...)
  let format = a:0 >= 1 ? a:1 : '{%d}'
  let flag = ""
  if flag == "" && exists("*SyntasticStatuslineFlag")
    let flag = SyntasticStatuslineFlag()
  endif
  if flag == "" && exists("*ALEGetStatusLine")
    let total = ale#statusline#Count(bufnr('%')).total
    let flag = total == 0 ? '' : printf(format, total)
  endif
  return flag
endf

fun! mg#statusline(...)
  let variant = a:0 >= 1 ? a:1 : ''
  return s:eval('statusline', {'variant': variant})
endf

fun! mg#tabline_eval_tabs(options)
  let s = ''
  for i in range(1, tabpagenr('$'))
    let options = copy(a:options)
    let options.nr = i
    if i == tabpagenr()
      let s .= s:eval('active_tab', options)
    else
      let s .= s:eval('inactive_tab', options)
    endif
  endfor
  return s
endf

fun! mg#tabline_eval_nr(options)
  return a:options.nr
endf

fun! mg#tabline_eval_name(options)
  let buflist = tabpagebuflist(a:options.nr)
  let winnr = tabpagewinnr(a:options.nr)
  let bufnr = buflist[winnr - 1]
  let name = s:shortpath(bufname(bufnr))
  if name == ''
    return '[No Name]'
  else
    return s:escape(name)
  endif
endf

fun! mg#tabline_eval_modified(options)
  let winnr = tabpagewinnr(a:options.nr)
  if gettabwinvar(a:options.nr, winnr, '&modified')
    return s:eval('modified_sign', a:options)
  else
    return ""
  endif
endf

fun! mg#tabline()
  return s:eval('tabline', {
        \ 'components': s:tabline,
        \ 'highlight': s:tabline_highlight,
        \ 'prefix': 'tabline',
        \ })
endf

call mg#tabline_highlight()
call mg#statusline_highlight()
redraw!
