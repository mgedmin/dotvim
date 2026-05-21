TAGHELPER_PLUGIN_API_VERSION = 1
TAGHELPER_SYNTAX = 'notes'


def parse(buffer, tags):
    for n, line in enumerate(buffer, 1):
        if not line or n == 1:
            continue
        if line[0] in '-=~' and line == line[0] * len(line):
            name = buffer[n - 2]
            tags.add(name, n-1, autoclose=True)
