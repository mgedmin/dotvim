fun! mg#fugitive#ShowMerge()
  let bufname = expand("%")
  let commit = matchstr(bufname, '^fugitive://.*/.git//\zs[0-9a-f]\{7,\}\ze')
  if commit == ""
    echo "Not looking at a vim-fugitive commit object"
    return
  endif
  " This relies on git find-merge alias from https://stackoverflow.com/a/30998048/110151
  silent let merge_commit = system("git find-merge " . commit)
  if merge_commit == ""
    echo "Could not find the merge commit for" commit
    return
  endif
  " I think we can assume that we have vim-fugitive if we're editing a
  " fugitive:// buffer
  exe "Gedit" merge_commit
endf
