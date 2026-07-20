# basically the same as taghelper_dosini.py


TAGHELPER_PLUGIN_API_VERSION = 1
TAGHELPER_SYNTAX = 'registry'


def parse(buffer, tags):
    curtag = None
    for n, line in enumerate(buffer, 1):
        if line.startswith('[') and ']' in line:
            section = line[:line.index(']') + 1]
            if section.startswith('[HKEY_LOCAL_MACHINE\\'):
                section = '[HKLM' + section.removeprefix('[HKEY_LOCAL_MACHINE')
            # can't do the same for HKEY_CURRENT_USER because the registry
            # dumps actually have [HKEY_USERS\S-...\...]
            if curtag:
                curtag.lastline = n - 1
            curtag = tags.add(section, n)
    if curtag:
        curtag.lastline = n
