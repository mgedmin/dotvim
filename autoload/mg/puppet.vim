function mg#puppet#includeexpr(fname)
  if a:fname =~ '^puppet:///modules/'
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
