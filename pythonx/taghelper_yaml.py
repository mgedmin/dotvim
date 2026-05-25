from __future__ import annotations

import re
import typing

import taghelper


TAGHELPER_PLUGIN_API_VERSION = 1
TAGHELPER_SYNTAX = 'yaml'


class Scope(typing.NamedTuple):
    indent: int
    qualname: str
    tag: taghelper.Tag


def parse(buffer, tags):
    key_rx = re.compile(r'^(\s*)([-_a-zA-Z][-_a-zA-Z0-9]*):\s*(?:#.*)?$')
    stack = []
    for n, line in enumerate(buffer, 1):
        m = key_rx.fullmatch(line)
        if m is None:
            continue
        indent = len(m[1].expandtabs())
        name = m[2]

        while stack and stack[-1].indent >= indent:
            stack[-1].tag.lastlineno = n - 1
            stack.pop()
        parent = stack[-1].qualname if stack else ''
        tag = tags.add(parent + name, n)
        stack.append(Scope(indent, parent + name + '.', tag))
