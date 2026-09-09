def add_import(buffer, module, name=''):
    in_docstring = False
    n_blanks = 0
    for lineno, line in enumerate(buffer):
        if line == '"""':
            in_docstring = not in_docstring
        if not in_docstring and not line.startswith('#'):
            words = line.split()
            if (
                'import' in words
                and module in words
                and (not name or name in words)
            ):
                return
        if line == "" and not in_docstring:
            n_blanks += 1
            if n_blanks == 2:
                if name:
                    buffer[lineno:lineno] = [
                        f'from {module} import {name}'
                    ]
                else:
                    buffer[lineno:lineno] = [f'import {module}']
                # TODO: ALEFix isort
                return
