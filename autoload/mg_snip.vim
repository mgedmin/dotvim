fun mg_snip#python_main_module()
  let packages = glob("src/*/__init__.py", 0, 1)
  if len(packages) == 1
    return packages[0][4:-13]
  endif
  let modules = glob("*.py", 0, 1)->filter({idx, fn -> fn !~ '^setup.py$\|^test'})
  if len(modules) == 1
    return modules[0][:-4]
  endif
  let dirname = expand("%:p:h:t")
  let candidate = dirname->substitute('-', '_', 'g')->substitute('\.', '/', 'g')
  if filereadable(candidate . ".py") || filereadable(candidate . "/__init__.py")
    return candidate
  endif
  return ""
endf
