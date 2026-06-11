function mg#vim#includeexpr(fname)
  " mg#foo#bar() -> find ~/.vim/autoload/mg/foo.vim
  " Plug 'owner/repo' -> find ~/.vim/bundle/repo/
  if a:fname =~ '^mg#'
    return '~/.vim/autoload/' .. a:fname->substitute('#[^#]*$', '.vim', '')->tr('#', '/')
  endif
  return substitute(a:fname, '^.*/', '', '')
endf
