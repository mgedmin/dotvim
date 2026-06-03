"""
Helpers for UltiSnips snippets
"""

import os
import subprocess


def name_of_parent_directory(path=''):
    """Return the basename of the parent directory.

    Example:

        >>> name_of_parent_directory('/home/mg/src/myproject/setup.py')
        'myproject'

    """
    return os.path.basename(os.path.dirname(os.path.abspath(path)))


def git_url(path='', default=''):
    """Return the URL of the git repository containing path.

    Maps git@github.com:owner/repo.git to https://github.com/owner/repo.
    """
    wd = os.path.dirname(os.path.abspath(path))
    if not os.path.isdir(wd):
        return default
    result = subprocess.run(
        ["git", "ls-remote", "--get-url"], capture_output=True, text=True
    )
    remote = result.stdout.strip()
    if remote.startswith('git@github.com:'):
        rest = remote.removeprefix('git@github.com:').removesuffix('.git')
        remote = 'https://github.com/' + rest
    return remote or default


def adjust_indent(snip, indent=0):
    """Adjust the indentation level of the snippet to ``indent`` spaces.

    Use it in the ``pre_expand`` section like this::

        pre_expand "adjust_indent(snip, 0)"
        snippet test "pytest test function" b
        def test_${1:something}():
            assert ${2:...}

        endsnippet

    It is helpful when regular expansion would result in a staircase effect::

        --- step 1
        test<tab>

        --- step 2
        def test_one_thing():
            assert ...

            test<tab>

        --- step 3, without adjust_indent
        def test_one_thing():
            assert ...

            def test_another_thing():
                assert ...

        --- step 3, with adjust_indent
        def test_one_thing():
            assert ...

        def test_another_thing():
            assert ...

    """
    snip.buffer[snip.line] = '' * indent
    snip.cursor.set(snip.line, indent)


def blank_lines_above(snip, count=2, except_at_start_of_file=0):
    """Adjust the number of blank lines above the snippet

    ``count`` can be a tuple (mincount, maxcount).

    Use it like this::

        post_expand "blank_lines_above(snip, 2)"
        snippet test "pytest test function" b
        def test_${1:something}():
            assert ${2:...}
        endsnippet

    """
    how_many = 0
    line = snip.snippet_start[0] - 1
    while line > 0 and snip.buffer[line] == "":
        how_many += 1
        line -= 1
    line = snip.snippet_start[0]
    if line == how_many:
        count = except_at_start_of_file
    if isinstance(count, tuple):
        mincount, maxcount = count
    else:
        mincount = maxcount = count
    while how_many < mincount:
        snip.buffer[line:line] = ['']
        how_many += 1
    while how_many > maxcount:
        line -= 1
        del snip.buffer[line]
        how_many -= 1


def blank_lines_below(snip, count=2, except_at_end_of_file=0):
    """Adjust the number of blank lines below the snippet

    ``count`` can be a tuple (mincount, maxcount).

    Use it like this::

        post_expand "blank_lines_below(snip, 2)"
        snippet test "pytest test function" b
        def test_${1:something}():
            assert ${2:...}
        endsnippet

    """
    how_many = 0
    line = snip.snippet_end[0] + 1
    while line > snip.snippet_start[0] and snip.buffer[line - 1] == "":
        line -= 1
    while line < len(snip.buffer) and snip.buffer[line] == "":
        how_many += 1
        line += 1
    if line == len(snip.buffer):
        count = except_at_end_of_file
    if isinstance(count, tuple):
        mincount, maxcount = count
    else:
        mincount = maxcount = count
    while how_many < mincount:
        snip.buffer[line:line] = ['']
        how_many += 1
    while how_many > maxcount:
        line -= 1
        del snip.buffer[line]
        how_many -= 1


def blank_lines_around(snip, count=2):
    """Adjust the number of blank lines around the snippet.

    ``count`` can be a tuple (mincount, maxcount).

    Use it like this::

        post_expand "blank_lines_around(snip, 2)"
        snippet test "pytest test function" b
        def test_${1:something}():
            assert ${2:...}
        endsnippet

    """
    blank_lines_above(snip, count)
    blank_lines_below(snip, count)
