import re
import typing

import taghelper


TAGHELPER_PLUGIN_API_VERSION = 1
TAGHELPER_SYNTAX = 'java'


class Scope(typing.NamedTuple):
    indent: int
    qualname: str
    tag: taghelper.Tag


def parse(buffer, tags):
    class_rx = re.compile(
        r'^(\s*)(?:public|private)\s+(?:static\s+)?(?:abstract\s+)?'
        r'class\s+(\w+)'
    )
    method_rx = re.compile(
        r'^(\s*)(?:public|private|static)\s+[^(=]*\s+(\w+)[(]'
    )
    close_rx = re.compile(r'^(\s*)}')
    stack = []
    for n, line in enumerate(buffer, 1):
        if m := (class_rx.match(line) or method_rx.match(line)):
            indent = len(m[1].expandtabs())
            name = m[2]
            while stack and stack[-1].indent >= indent:
                stack[-1].tag.close(n - 1)
                stack.pop()
            parent = stack[-1].qualname if stack else ''
            tag = tags.add(parent + name, n)
            stack.append(Scope(indent, parent + name + '.', tag))
        elif m := close_rx.match(line):
            indent = len(m[1].expandtabs())
            while stack and stack[-1].indent >= indent:
                stack[-1].tag.close(n)
                stack.pop()
