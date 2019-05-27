function! TabOnFirstColumnOnly()
  setlocal expandtab
  if col(".") == 1
    return "\<C-V>\<Tab>"
  else
    if exists("*UltiSnips#ExpandSnippetOrJump")
      call UltiSnips#ExpandSnippetOrJump()
      if g:ulti_expand_or_jump_res > 0
        return ""
      endif
    endif
    return "\<Tab>"
  endif
endf

inoremap <buffer> <Tab> <C-R>=TabOnFirstColumnOnly()<CR>
