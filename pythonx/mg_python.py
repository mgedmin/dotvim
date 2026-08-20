# https://packaging.python.org/en/latest/specifications/inline-script-metadata/#reference-implementation
# also known as PEP 723
import re
import tomllib

import vim  # type: ignore[import-not-found]


REGEX = r'(?m)^# /// (?P<type>[a-zA-Z0-9-]+)$\s(?P<content>(^#(| .*)$\s)+)^# ///$'


def extract_script_metadata(script: str) -> dict | None:
    name = 'script'
    matches = list(
        filter(lambda m: m.group('type') == name, re.finditer(REGEX, script))
    )
    if len(matches) > 1:
        raise ValueError(f'Multiple {name} blocks found')
    elif len(matches) == 1:
        content = ''.join(
            line[2:] if line.startswith('# ') else line[1:]
            for line in matches[0].group('content').splitlines(keepends=True)
        )
        return tomllib.loads(content)
    else:
        return None


def extract_script_dependencies(script: str) -> list[str]:
    metadata = extract_script_metadata(script)
    if not metadata or not metadata.get('dependencies'):
        return []
    return metadata['dependencies']


def extract_current_script_dependencies() -> list[str]:
    return extract_script_dependencies('\n'.join(vim.current.buffer))
