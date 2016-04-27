" This is going to be the GREATEST VIM PLUGIN EVAR!!!!!1

if v:version < 700
  finish
endif

inoremap <silent> ( (<C-R>=ShowFunctionSignature()<CR>
inoremap <silent> <C-L> <C-O><C-L><C-R>=ShowFunctionSignature()<CR>

function! FindBestTagsForName(name, method, class)
  silent! let tags = taglist('^' . a:name . '$')
  if a:method
    let filtered_tags = filter(copy(tags), 'has_key(v:val, "class")')
    " could be module.ClassName too
    if !empty(filtered_tags)
      let tags = filtered_tags
      if a:class != ""
        let filtered_tags = filter(copy(tags), 'v:val.class == a:class')
        if !empty(filtered_tags)
          let tags = filtered_tags
        endif
      endif
    endif
  else
    call filter(tags, '!has_key(v:val, "class")')
  endif
  let tests = filter(copy(tags), 'v:val["filename"] =~ "test"')
  let tags = filter(tags, 'v:val["filename"] !~ "test"') + tests
  return tags
endfunction

function! GetAllConstructors()
  let signature = map(tagfiles(), 'v:val . ":" . getftime(v:val)')
  if !exists("g:pfc_init_tags_cache") || !exists("g:pfc_init_tags_signature")
        \ || signature != g:pfc_init_tags_signature
    let g:pfc_init_tags_signature = signature
    let g:pfc_init_tags_cache = taglist('^__init__$')
  endif
  return g:pfc_init_tags_cache
endfunction

function! FindConstructorForClass(name)
  let tags = copy(GetAllConstructors())
  let tags = filter(tags, 'has_key(v:val, "class") && v:val["class"] == a:name')
  return tags
endfunction

function! GetWordLeftOfCursor()
  let line = getline('.')
  " magick adjustment to the left:
  "    word(X...
  "    123456  <= col('.') is 6
  "    0123    <= string indices
  let col = col('.') - 3
  if col('.') == col('$') - 1
    " special case for end of line
    "    word(X
    "    12345   <= col('.') is 5, col('$') is 6
    "    0123    <= string indices
    let col = col + 1
  endif
  if col < 0
    return ""
  endif
  let word = matchstr(line[:col], '[.]\=[a-zA-Z_][a-zA-Z_0-9]*$')
  return word
endfunction

function! ShowFunctionSignature(...)
  if a:0 == 0
    let name = GetWordLeftOfCursor()
  else
    let name = a:1
  endif
  if name == ''
    return ''
  endif
  if name[0] == '.'
    let name = name[1:]
    let class = ''
    let is_method = 1
  elseif name =~ '[.]'
    let [class, name] = split(name, '[.]')
    let is_method = 1
  else
    let class = ''
    let is_method = 0
  endif
  let tags = FindBestTagsForName(name, is_method, class)
  if tags == []
    return ''
  endif

  echo "Searching for " . name . "..."

  if tags[0]['kind'] == 'c'
    let tags = FindConstructorForClass(name)
    if tags == []
      echon " not found"
      return ''
    endif
  endif

  let nth = 0
  if exists("b:PFS_last_pos") && b:PFS_last_pos == getpos(".")
    let nth = b:PFS_last_nth + 1
    if nth >= len(tags)
      let nth = 0
    endif
  endif
  let b:PFS_last_pos = getpos(".")
  let b:PFS_last_nth = nth
  let tag = tags[nth]
  let signature = tag['cmd']
  let signature = substitute(signature, '^/^', '', '')
  let signature = substitute(signature, '$/$', '', '')
  let signature = substitute(signature, '^\s*def ', '', '')
  let signature = substitute(signature, '(self, ', '(', '')
  let signature = substitute(signature, ',$', ', ...', '')
  let signature = substitute(signature, ':$', '', '')
  if has_key(tag, 'class')
    let signature = tag['class'] . '.' . signature
  endif
  if len(tags) > 1
    let signature = signature . " and " . (len(tags) - 1) . " more "
  endif
  let signature = signature . "  "
  let filename = tag['filename']
  let width = &columns - len(signature)
  if len(filename) > width
    let width = width - 3
    if width > 0
      let filename = '...' . filename[len(filename)-width :]
    else
      let filename = ''
    endif
  else
    let filename = printf("%*s", width, filename)
  endif
  echon "\r" . signature . filename
  return ''
endfunction

" Example: queryAdapter(, getAdapter, queryUtility(
" TestRequest(  __init__(  def __init__(
" provideAdapter(
" queryUtility(
" TestRequest(
" interfaces.Invalid(
