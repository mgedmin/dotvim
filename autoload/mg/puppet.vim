function mg#puppet#includeexpr(fname, oldfile='%')
  if a:fname =~ '^puppet:///modules/${module_name}/'
    " given
    "   source => 'puppet:///modules/${module_name}/file.txt'
    " while editing modules/modname/manifests/*.pp, the file I want is
    "   modules/modname/files/file.txt
    let module_dir = expand(a:oldfile .. ':h:h')
    return substitute(a:fname, '^puppet:///modules/${module_name}/', module_dir .. '/files/', '')
  elseif a:fname =~ '^puppet:///modules/'
    " given
    "   source => 'puppet:///modules/mymodule/file.txt'
    " the file I want is
    "   modules/mymodule/files/file.txt
    return substitute(a:fname, '^puppet:///modules/\([^/]\+\)/', 'modules/\1/files/', '')
  else
    " given
    "   content => epp('mymodule/filename.epp')
    " the file I want is
    "   modules/mymodule/templates/filename.epp
    return substitute(a:fname, '^\([^/]\+\)/', 'modules/\1/templates/', '')
  endif
endf

" au BufReadCmd puppet:///* ++nested call mg#puppet#bufreadcmd(expand('<amatch>')
function mg#puppet#bufreadcmd(fname)
  let found = mg#puppet#includeexpr(a:fname, '#')
  if found != a:fname
    exe 'keepalt e' found
    exe 'silent! keepalt bdelete' a:fname
  endif
endf
