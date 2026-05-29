" Used to make <f8> show the number of matches after highlighting them
fun! mg#show#search_count()
  if exists("*searchcount")
    echo searchcount({'maxcount': 0}).total "matches"
  endif
endf
