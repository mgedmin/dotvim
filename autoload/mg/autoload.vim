let g:mg#autoload#root = "~/.vim/autoload/mg"

fun mg#autoload#path_of(name)
  return g:mg#autoload#root . "/" . a:name
endf

fun mg#autoload#complete(arg_lead, cmdline, cursor_pos)
  return g:mg#autoload#root->expand()->readdir()->join("\n")
endf
