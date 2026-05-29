import re


TAGHELPER_PLUGIN_API_VERSION = 1
TAGHELPER_SYNTAX = ('sh', 'bash')


FUNCTION_RX = re.compile(r'^(?:function\s+)?(\w+)\s*[(][)]\s*[{]')
END_RX = re.compile('^}')


def parse(buffer, tags):
    for n, line in enumerate(buffer, 1):
        if m := FUNCTION_RX.match(line):
            name = m[1]
            tags.add(name, n, autoclose=True)
        elif m := END_RX.match(line):
            tags.autoclose(n)
