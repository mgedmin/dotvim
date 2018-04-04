" Overrides for Python files

" I don't want [I to parse import statements and look for modules
setlocal include=

" fo+=j and comments+=fb:- means that 'x \n - y' gets joined into 'x y'
" instead of 'x - y', which is not what I want in arithmetic expressions!
setlocal comments=b:#
