" Human-readable description of my statusline.  Ha!
" This maps component names to definitions, which can use Vim's statusline
" escapes or refer to other components via {name}.
" The main component is called 'statusline'.
" Components can have variations, mentioned in square brackets, for different
" buftypes.
let s:statusline = {
      \ 'statusline': '{left} %={right}',
      \ 'left[quickfix]': '{quickfix_tail}{quickfix_title}',
      \ 'left[help]': '{help_prefix} %<{filename}',
      \ 'left': '%<{filename}%( {flags}%){errors}',
      \ 'right': '{tag}{pos}{position}',
      \ 'tag': '%{mg#statusline_tag(" %s ")}',
      \ 'bufnr': '%n',
      \ 'filename': '%f',
      \ 'help_prefix': ' Help ',
      \ 'quickfix_tail': ' %t ',
      \ 'quickfix_title': "%{exists('w:quickfix_title') ? ' '.w:quickfix_title : ''}",
      \ 'flags': '{help}{modified}{ro}{lcd}',
      \ 'help': '%h',
      \ 'modified': '%m',
      \ 'modified[terminal]': '',
      \ 'ro': '%r',
      \ 'errors': '%{mg#statusline_errors(" %d ")}',
      \ 'position': ' %3l:%-2v ',
      \ 'line': '%l',
      \ 'col': '%c',
      \ 'maybe_virtual': '%V',
      \ 'total_lines': '%4L',
      \ 'pos': ' %P ',
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
      \ 'name': '{filename}',
      \ 'name[help]': '{tail}',
      \ 'name[terminal]': '{filename}{termtitle}',
      \ 'modified[terminal]': '',
      \ 'name_empty': '[No Name]',
      \ 'termtitle_empty': '',
      \ 'termtitle_finished': ' [finished]',
      \ 'termtitle_nonempty': ' [%s]',
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
let s:inactive_fg = [ '#8a8a8a', 245 ]
let s:inactive_bg = [ '#303030', 236 ]
let s:inactive_l1_fg = [ '#585858', 240 ]
let s:inactive_l1_bg = [ '#262626', 235 ]
let s:inactive_r1_fg = [ '#262626', 235 ]
let s:inactive_r1_bg = [ '#606060', 241 ]
let s:inactive_r2_fg = [ '#585858', 240 ]
let s:inactive_r2_bg = [ '#262626', 235 ]
let s:inactive_tag_fg = [ '#949494', 246 ]
let s:inactive_tag_bg = [ '#005f00', 22 ]
" and for tabline
let s:active_fg = [ '#bcbcbc', 250 ]
let s:active_bg = [ '#262626', 235 ]
let s:inactive_fg = [ '#bcbcbc', 250 ]
let s:inactive_bg = [ '#585858', 240 ]
let s:middle_fg = [ '#303030', 236 ]
let s:middle_bg = [ '#9e9e9e', 247 ]
let s:close_fg = [ '#bcbcbc', 250 ]
let s:close_bg = [ '#4e4e4e', 239 ]

fun! mg#highlight(group, fg, bg, extra)
  exec 'hi '.a:group.' ctermfg='.a:fg[1].' ctermbg='.a:bg[1].' guifg='.a:fg[0].' guibg='.a:bg[0] . ' ' . a:extra
endf

fun! mg#statusline_highlight_part(part, fg, bg)
  call mg#highlight('mg_statusline_'.a:part, a:fg, a:bg, '')
endf

fun! mg#statusline_highlight()
  call mg#highlight('StatusLineNC', s:inactive_fg, s:inactive_bg, 'term=NONE cterm=NONE gui=NONE')
  call mg#statusline_highlight_part('l1', s:l1_fg, s:l1_bg)
  call mg#statusline_highlight_part('r1', s:r1_fg, s:r1_bg)
  call mg#statusline_highlight_part('r2', s:r2_fg, s:r2_bg)
  call mg#statusline_highlight_part('tag', s:tag_fg, s:tag_bg)
  call mg#statusline_highlight_part('l1_inactive', s:inactive_l1_fg, s:inactive_l1_bg)
  call mg#statusline_highlight_part('r1_inactive', s:inactive_r1_fg, s:inactive_r1_bg)
  call mg#statusline_highlight_part('r2_inactive', s:inactive_r2_fg, s:inactive_r2_bg)
  call mg#statusline_highlight_part('tag_inactive', s:inactive_tag_fg, s:inactive_tag_bg)
endf

fun! mg#tabline_highlight_part(part, fg, bg)
  call mg#highlight('mg_tabline_'.a:part, a:fg, a:bg, '')
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
  let active = get(a:options, "active", 1)
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
    if active && hlID(highlight . "_active") != 0
      let highlight .= "_active"
    elseif !active && hlID(highlight . "_inactive") != 0
      let highlight .= "_inactive"
    endif
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
  let active = a:0 >= 2 ? a:2 : 1
  let s:active_winnr = winnr()
  return s:eval('statusline', {'variant': variant, 'active': active})
endf

fun! mg#statusline_enable()
  let s:statusline_enabled = 1
  call mg#statusline_highlight()
  call mg#statusline_update()
  augroup mg#statusline
    au!
    au TabEnter * call mg#statusline_update()
    " Mystery: I need WinEnter/WinLeave to correctly update when switching
    " between windows, but I also need BufWinEnter to correctly initialize
    " when I do :tabnew.
    au WinEnter,BufWinEnter * let &l:statusline = mg#statusline(&buftype, 1)
    au WinLeave,BufWinLeave * let &l:statusline = mg#statusline(&buftype, 0)
    au ColorScheme * call mg#statusline_highlight()
  augroup END
endf

fun! mg#statusline_update()
  let curwin = winnr()
  for i in range(1, winnr('$'))
    let buftype = getwinvar(i, '&buftype')
    let active = i == curwin
    call setwinvar(i, '&statusline', mg#statusline(buftype, active))
  endfor
endf

fun! mg#statusline_disable()
  let s:statusline_enabled = 0
  let curwin = winnr()
  for i in range(1, tabpagenr('$'))
    for j in range(1, winnr('$'))
      call settabwinvar(i, j, '&statusline', '')
    endfor
  endfor
  augroup mg#statusline
    au!
  augroup END
endf

fun! mg#tabline_eval_tabs(options)
  let s = ''
  for i in range(1, tabpagenr('$'))
    let options = copy(a:options)
    let options.nr = i
    let options.winnr = tabpagewinnr(options.nr)
    let options.variant = gettabwinvar(options.nr, options.winnr, "&buftype")
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

fun! mg#tabline_eval_filename(options)
  let buflist = tabpagebuflist(a:options.nr)
  let winnr = tabpagewinnr(a:options.nr)
  let bufnr = buflist[winnr - 1]
  let name = s:shortpath(bufname(bufnr))
  if name == ''
    return s:eval('name_empty', a:options)
  else
    return s:escape(name)
  endif
endf

fun! mg#tabline_eval_tail(options)
  let buflist = tabpagebuflist(a:options.nr)
  let winnr = tabpagewinnr(a:options.nr)
  let bufnr = buflist[winnr - 1]
  let name = fnamemodify(bufname(bufnr), ":t")
  if name == ''
    return s:eval('name_empty', a:options)
  else
    return s:escape(name)
  endif
endf

fun! mg#tabline_eval_termtitle(options)
  let buflist = tabpagebuflist(a:options.nr)
  let winnr = tabpagewinnr(a:options.nr)
  let bufnr = buflist[winnr - 1]
  let title = term_gettitle(bufnr)
  if title == ''
    let status = term_getstatus(bufnr)
    if status == 'finished'
      return s:eval('termtitle_finished', a:options)
    else
      return s:eval('termtitle_empty', a:options)
    endif
  else
    return s:escape(printf(s:eval('termtitle_nonempty', a:options), title))
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

fun! mg#tabline_enable()
  let s:tabline_enabled = 1
  call mg#tabline_highlight()
  set tabline=%!mg#tabline()
  augroup mg#tabline
    au!
    au ColorScheme * call mg#tabline_highlight()
  augroup END
endf

fun! mg#tabline_disable()
  let s:tabline_enabled = 0
  set tabline&
  augroup mg#tabline
    au!
  augroup END
endf

let s:redraw = 0
if get(s:, 'statusline_enabled', 0)
  call mg#statusline_enable()
  let s:redraw = 1
endif
if get(s:, 'tabline_enabled', 0)
  call mg#tabline_enable()
  let s:redraw = 1
endif
if s:redraw
  redraw!
endif
