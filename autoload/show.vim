fun! show#search_count()
  if exists("*searchcount")
    echo searchcount({'maxcount': 0}).total "matches"
  endif
endf
