" Human-readable description of my statusline.  Ha!
" This maps component names to definitions, which can use Vim's statusline
" escapes or refer to other components via {name}.
" The main component is called 'statusline'.
" Components can have variations, mentioned in square brackets, for different
" buftypes.
let s:statusline = {
      \ 'statusline': '{bufnr}{lcd}%<{left} %={right}',
      \ 'left[quickfix]': '{quickfix_tail}{quickfix_title}',
      \ 'left[help]': '{help_prefix} %<{filename}',
      \ 'left[terminal]': ' %f%( {flags}%)',
      \ 'statusline[nerdtree]': '{nerdtree_prefix} %={pos}',
      \ 'left': ' {directory}{filename}%( {flags}%)',
      \ 'right': '{tag}{errors}{pos}{position}',
      \ 'bufnr[quickfix]': '',
      \ 'bufnr[help]': '',
      \ 'bufnr': ' %n ',
      \ 'filename': '%t',
      \ 'nerdtree_prefix': ' NERDTree ',
      \ 'help_prefix': ' Help ',
      \ 'quickfix_tail': ' %t ',
      \ 'quickfix_title': "%{exists('w:quickfix_title') ? ' '.w:quickfix_title : ''}",
      \ 'flags': '{help}{modified}{ro}{git_status}',
      \ 'help': '%h',
      \ 'modified': '%m',
      \ 'modified[terminal]': '',
      \ 'ro': '%r',
      \ 'position': ' %3l:%-2v ',
      \ 'line': '%l',
      \ 'col': '%c',
      \ 'maybe_virtual': '%V',
      \ 'total_lines': '%4L',
      \ 'pos': ' %P ',
      \ }
let s:statusline_highlight = {
      \ 'directory': 'mg_statusline_directory',
      \ 'tag': 'mg_statusline_tag',
      \ 'lcd': 'mg_statusline_lcd',
      \ 'errors': 'mg_statusline_error',
      \ 'nerdtree_prefix': 'mg_statusline_l1',
      \ 'help_prefix': 'mg_statusline_l1',
      \ 'quickfix_tail': 'mg_statusline_l1',
      \ 'bufnr': 'mg_statusline_l1',
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
      \ 'close': '%999X ⨯ ',
      \ }
let s:tabline_highlight = {
      \ 'active_tab': 'mg_tabline_active',
      \ 'inactive_tab': 'mg_tabline_inactive',
      \ 'middle': 'mg_tabline_middle',
      \ 'close': 'mg_tabline_close',
      \ }

" colors based on lightline.vim's powerline theme
let s:lcd_fg = [ '#d0d0d0', 252 ]
let s:lcd_bg = [ '#ac7ea8', 13 ]
let s:l1_fg = [ '#ffffff', 231 ]
let s:l1_bg = [ '#585858', 240 ]
let s:r1_fg = [ '#606060', 241 ]
let s:r1_bg = [ '#d0d0d0', 252 ]
let s:r2_fg = [ '#bcbcbc', 250 ]
let s:r2_bg = [ '#585858', 240 ]
let s:tag_fg = [ '#d0d0d0', 252 ]
let s:tag_bg = [ '#008700', 28 ]
let s:directory_fg = s:tag_fg
let s:error_fg = [ '#ededeb', 15 ]
let s:error_bg = [ '#ef2828', 9 ]
let s:active_fg = [ '#ffffff', 231 ]
let s:active_bg = [ '#000000', 0 ]
let s:inactive_fg = [ '#8a8a8a', 245 ]
let s:inactive_bg = [ '#303030', 236 ]
let s:inactive_lcd_fg = [ '#949494', 246 ]
let s:inactive_lcd_bg = [ '#754f7b', 5 ]
let s:inactive_l1_fg = [ '#585858', 240 ]
let s:inactive_l1_bg = [ '#262626', 235 ]
let s:inactive_r1_fg = [ '#262626', 235 ]
let s:inactive_r1_bg = [ '#606060', 241 ]
let s:inactive_r2_fg = [ '#585858', 240 ]
let s:inactive_r2_bg = [ '#262626', 235 ]
let s:inactive_tag_fg = [ '#949494', 246 ]
let s:inactive_tag_bg = [ '#005f00', 22 ]
let s:inactive_directory_fg = s:inactive_fg
let s:inactive_directory_bg = s:inactive_bg
let s:inactive_error_fg = [ '#949494', 246 ]
let s:inactive_error_bg = [ '#af0000', 124 ]
" and for tabline
let s:active_tab_fg = [ '#bcbcbc', 250 ]
let s:active_tab_bg = [ '#262626', 235 ]
let s:inactive_tab_fg = [ '#bcbcbc', 250 ]
let s:inactive_tab_bg = [ '#585858', 240 ]
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

fun! s:statusline_bg_for(mode)
  let reverse = synIDattr(synIDtrans(hlID("StatusLine")), "reverse", a:mode)
  let which = reverse ? "fg" : "bg"
  let color = synIDattr(synIDtrans(hlID("StatusLine")), which, a:mode)
  return color == "" ? "black" : color
endf

fun! s:statusline_bg()
  " Bit of a hack there: I assume the statusline uses reverse video
  let gui_fg = s:statusline_bg_for("gui")
  let cterm_fg = s:statusline_bg_for("cterm")
  return [ gui_fg, cterm_fg ]
endf

highlight User3                 ctermfg=245

fun! mg#statusline_highlight()
  call mg#highlight('StatusLine', s:active_fg, s:statusline_bg(), 'term=bold cterm=bold gui=bold')
  call mg#highlight('StatusLineNC', s:inactive_fg, s:inactive_bg, 'term=NONE cterm=NONE gui=NONE')
  call mg#statusline_highlight_part('lcd', s:lcd_fg, s:lcd_bg)
  call mg#statusline_highlight_part('l1', s:l1_fg, s:l1_bg)
  call mg#statusline_highlight_part('r1', s:r1_fg, s:r1_bg)
  call mg#statusline_highlight_part('r2', s:r2_fg, s:r2_bg)
  call mg#statusline_highlight_part('tag', s:tag_fg, s:tag_bg)
  call mg#statusline_highlight_part('error', s:error_fg, s:error_bg)
  call mg#statusline_highlight_part('directory', s:directory_fg, s:statusline_bg())
  call mg#statusline_highlight_part('lcd_inactive', s:inactive_lcd_fg, s:inactive_lcd_bg)
  call mg#statusline_highlight_part('l1_inactive', s:inactive_l1_fg, s:inactive_l1_bg)
  call mg#statusline_highlight_part('r1_inactive', s:inactive_r1_fg, s:inactive_r1_bg)
  call mg#statusline_highlight_part('r2_inactive', s:inactive_r2_fg, s:inactive_r2_bg)
  call mg#statusline_highlight_part('tag_inactive', s:inactive_tag_fg, s:inactive_tag_bg)
  call mg#statusline_highlight_part('error_inactive', s:inactive_error_fg, s:inactive_error_bg)
  call mg#statusline_highlight_part('directory_inactive', s:inactive_directory_fg, s:inactive_directory_bg)
endf

fun! mg#tabline_highlight_part(part, fg, bg)
  call mg#highlight('mg_tabline_'.a:part, a:fg, a:bg, '')
endf

fun! mg#tabline_highlight()
  call mg#tabline_highlight_part('active', s:active_tab_fg, s:active_tab_bg)
  call mg#tabline_highlight_part('inactive', s:inactive_tab_fg, s:inactive_tab_bg)
  call mg#tabline_highlight_part('middle', s:middle_fg, s:middle_bg)
  call mg#tabline_highlight_part('close', s:close_fg, s:close_bg)
endf


if has('lambda')
  fun! s:expand(s, options)
    return substitute(a:s, '{\([a-z_]\+\)}', {m -> s:eval(m[1], a:options)}, 'g')
  endf
else
  fun! s:expand(s, options)
    let bits = split(a:s, '\ze{[a-z_]\+}')
    let result = []
    for bit in bits
      if bit != "" && bit[0] == '{'
        let [name, rest] = split(bit[1:], "}", 1)
        let bit = s:eval(name, a:options) . rest
      endif
      call add(result, bit)
    endfor
    return join(result, "")
  endf
endif

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
  return "%#" . a:group_name . "#" . a:s . "%*"
endf

fun! s:optimize(s)
  " also fixes a bug in vim where %(%#foo#...%*%)%#bar#...%* gets it confused
  " about the correct width
  return substitute(a:s, '%\*\(%[()]\)\=%#', '\1%#', 'g')
endf

fun! s:escape(s)
  return substitute(a:s, '%', '%%', 'g')
endf

fun! s:shortpath(path)
  return a:path != "" ? pathshorten(fnamemodify(a:path, ":~:.")) : ""
endf

fun! s:mediumpath(path)
  return a:path != "" ? fnamemodify(a:path, ":~:.") : ""
endf

fun! mg#statusline_lcd()
  let format = a:0 >= 1 ? a:1 : ' %s '
  return haslocaldir() ? printf(format, 'lcd') : ''
endf

fun! mg#statusline_directory()
  return substitute(s:mediumpath(bufname('')), '[^/]*$', '', '')
endf

fun! mg#statusline_invalidate_git_cache()
  if exists("b:git_status")
    unlet b:git_status
  endif
endf

let s:git_status_mappings = {
      \ "!!": "ignored",
      \ "??": "unknown",
      \ }

fun! mg#statusline_git_status()
  let format = a:0 >= 1 ? a:1 : '[git:%s]'
  let tracked = a:0 >= 2 ? a:2 : '[git]'
  if !exists("b:git_status")
    let b:git_status = ''
    if exists('*fugitive#repo') && filereadable(expand("%"))
      try
        let path = fugitive#buffer().path()
        let status = fugitive#repo().git_chomp_in_tree('status', '--porcelain', '--ignored', '--', path)[:1]
        if status == ""
          let status = "  "
        endif
        let b:git_status = status
      catch /.*/
      endtry
    endif
  endif
  let status = get(s:git_status_mappings, b:git_status, b:git_status)
  if status == ""
    return ""
  elseif status == "  "
    return tracked
  else
    return printf(format, status)
  endif
endf

fun! mg#statusline_tag(...)
  let format = a:0 >= 1 ? a:1 : ' %s '
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
  let format = a:0 >= 1 ? a:1 : ' %d '
  let flag = ""
  if flag == "" && exists("*SyntasticStatuslineFlag")
    let flag = SyntasticStatuslineFlag()
  endif
  if flag == "" && exists(":ALELint")
    let total = ale#statusline#Count(bufnr('%')).total
    let flag = total == 0 ? '' : printf(format, total)
  endif
  return flag
endf

fun! mg#statusline(...)
  let buftype = a:0 >= 1 ? a:1 : ''
  let filetype = a:0 >= 2 ? a:2 : ''
  let active = a:0 >= 3 ? a:3 : 1
  let variant = mg#statusline_variant(buftype, filetype)
  let s:active_winnr = winnr()
  return s:optimize(s:eval('statusline', {'variant': variant, 'active': active}))
endf

fun! mg#statusline_variant(buftype, filetype)
  if a:buftype =~ '^\(quickfix\|help\|terminal\)$'
    return a:buftype
  else
    return a:filetype
  endif
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
    au WinEnter,BufWinEnter * let &l:statusline = mg#statusline(&buftype, &filetype, 1)
    au WinLeave,BufWinLeave * let &l:statusline = mg#statusline(&buftype, &filetype, 0)
    au ColorScheme * call mg#statusline_highlight()
    au BufEnter,BufWritePost,ShellCmdPost,FocusGained * call mg#statusline_invalidate_git_cache()
  augroup END
endf

fun! mg#statusline_update()
  call mg#statusline_invalidate_git_cache()
  let curwin = winnr()
  for i in range(1, winnr('$'))
    let buftype = getwinvar(i, '&buftype')
    let filetype = getwinvar(i, '&filetype')
    let active = i == curwin
    call setwinvar(i, '&statusline', mg#statusline(buftype, filetype, active))
  endfor
endf

fun! mg#statusline_disable()
  let s:statusline_enabled = 0
  let curwin = winnr()
  for i in range(1, tabpagenr('$'))
    for j in range(1, tabpagewinnr(i, '$'))
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
