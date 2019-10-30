let s:python = has('python3') ? 'python3' : 'python'
exec s:python "<< END"
import os, re, vim, subprocess

class WebAnnotator(object):

    browser = 'xdg-open'

    def __init__(self):
        self.read_config()

    def syntax_error(self, filename, lineno, line):
        sys.stderr.write("%s:%d: syntax error: %s\n" % (filename, lineno, line))
        sys.stderr.flush()

    def read_config(self, filename='~/.vim/web-annotate.cfg'):
        self.patterns = []
        section = 'patterns'
        last_key = None
        try:
            with open(os.path.expanduser(filename)) as f:
                for lineno, line in enumerate(f, 1):
                    line = line.rstrip()
                    if not line or line.startswith('#'):
                        continue
                    if line[:1].isspace(): # continuation
                        line = line.strip()
                        if section == 'patterns':
                            if self.patterns:
                                self.patterns[-1][-1] += line
                                continue
                        elif section == 'config':
                            if last_key == 'browser':
                                self.browser += line
                                continue
                        self.syntax_error(filename, lineno, line)
                        continue
                    elif line.startswith('['):
                        if line.endswith(']'):
                            section = line[1:-1]
                            continue
                        section = None
                    elif '=' in line:
                        key, _, value = line.partition('=')
                        key = last_key = key.strip()
                        value = value.strip()
                        if section == 'patterns':
                            self.patterns.append([key, value])
                            continue
                        elif section == 'config':
                            if key == 'browser':
                                self.browser = value
                                continue
                    self.syntax_error(filename, lineno, line)
        except IOError:
            pass

    def open(self):
        filename = vim.eval('expand("%:p")')
        url, matchdict = self.match(filename)
        if not url:
            print("No matching filename pattern for %s" % filename)
            return
        url = self.substitute(url, matchdict)
        self.launch([self.browser, url])
        print(url)

    def match(self, filename):
        for pattern, url in self.patterns:
            rx = self.compile(pattern)
            m = rx.match(filename)
            if m:
                return url, m.groupdict()
        return None

    def compile(self, pattern):
        return re.compile(os.path.expanduser(pattern).format(
                    project='(?P<project>[-a-zA-Z0-9_.]+?)',
                    path='(?P<path>.*)') + '$')

    def substitute(self, url, matchdict):
        return url.format(svnbranch=self.get_svn_branch(),
                          gitbranch=self.get_git_branch(),
                          lineno=self.get_line_no(),
                          toplineno=self.get_top_line_no(),
                          **matchdict)

    def get_svn_branch(self):
        return 'trunk' # XXX: parse url from ./.svn or something

    def get_git_branch(self):
        return 'master' # XXX: parse .git/refs/HEAD or something

    def get_top_line_no(self):
        return vim.eval('line("w0")') # topmost visible line

    def get_line_no(self):
        return vim.eval('line(".")') # cursor line

    def launch(self, cmd):
        with open('/dev/null', 'w') as devnull:
            subprocess.Popen(cmd, stdout=devnull, stderr=devnull)

END

fun web_annotate#open()
  exec s:python "WebAnnotator().open()"
endf
