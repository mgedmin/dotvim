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
