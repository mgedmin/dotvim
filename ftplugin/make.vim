function! s:TabOnFirstColumnOnly()
  setlocal expandtab softtabstop=8
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

function! s:ResetOptions()
  setlocal noexpandtab
  return ""
endf

function! s:Backspace()
  setlocal softtabstop=8
  return "\<BS>"
endf

" <Tab>: insert spaces, except on 1st column insert a tab
inoremap <buffer> <Tab> <C-R>=<SID>TabOnFirstColumnOnly()<CR><C-R>=<SID>ResetOptions()<CR>

" <BS>: make sure softtabstop is set
inoremap <buffer> <expr> <BS> <SID>Backspace()

" ,p: add a .PHONY: above a make rule
noremap <buffer> ,p :s/^\ze\([-a-z]\+\):/.PHONY: \1\r/<bar>noh<CR>
