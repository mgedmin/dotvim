"
" File: smart-tag.vim
" Author: Marius Gedminas <marius@gedmin.as>
" Version: 0.2
" Last Modified: 2014-11-06
"
" Smarter :tag
"
" Usage:
"   :Tag name                   -- jump to a global function
"   :Tag class.name             -- jump to the right class method
"   :Tag module.class.name      -- jump to the right class method
"   :Tag module.class           -- jump to the right class
"   :Tag package.module.class   -- jump to the right class
"
" What the :Tag command does is search for tags matching the last part of a
" dotted name, and then filter them according to containing class/filename.
"
" Needs vim with Python support (because vimscript is painful to work in).
"
" Doesn't need a tags file with --extra=+q (which stopped working for Python
" anyway in some exuberant ctags version).
"

python << END
import vim

def smart_tag_jump(query):
    verbose = int(vim.eval('&verbose'))

    def command(cmd):
        if verbose > 0:
            print(cmd)
        vim.command(cmd)

    def debug(message):
        if verbose > 0:
            print(message)

    if not query:
        # XXX: it'd be nice to take the topmost name from the tag stack
        return

    bits = query.split('.')
    assert len(bits) > 0
    name = bits[-1]
    # Try [[package.]module.]class.name
    class_ = bits[-2] if len(bits) > 1 else None

    tags = vim.eval('taglist("^%s$")' % name)
    debug("Got %d tags for %s" % (len(tags), name))

    if class_:
        filtered = [t for t in tags if t.get("class") == class_]
        debug("%d tags matched class %s" % (len(filtered), class_))
    else:
        # look for top-level names
        filtered = [t for t in tags if not t.get("class")]
        debug("%d tags are top-level" % (len(filtered)))

    if not filtered:
        filtered = tags
        class_ = None
        debug("Discarding empty filtered list")

    if class_:
        filename_bits = '/'.join(bits[0:-2])
    else:
        filename_bits = '/'.join(bits[0:-1])

    if filename_bits:
        # XXX: this can match a substring of a filename, which would be a bug
        # what we want to match is directory names and filename-with-no-extension
        doubly_filtered = [t for t in filtered if filename_bits in t.get("filename")]
        debug("%d tags matched filename substring %s" % (len(doubly_filtered), filename_bits))
        if doubly_filtered:
            filtered = doubly_filtered
        else:
            debug("Discarding empty filtered list")

    if not filtered:
        print("Couldn't find %s" % query)
        return

    tag = filtered[0]
    index = tags.index(tag)

    # I'd like to do this because it pushes to the tag stack:
    command("%dtag %s" % (index + 1, name))
    # but I can't rely on it because the order of tags in :[count]tag
    # doesn't match the order of tags returned by taglist() due to
    # :h tag-priority sorting!
    # Doing both now because the :tag pushes the name onto the tag stack,
    # and then my :e will make sure I went to the right location
    command("keepjumps e %s" % tag["filename"])

    if tag.get('class') and tag['filename'].endswith('.py'):
        # Problem: when you've got a Python file with multiple classes
        # defining the same method (same name and signature), e.g.
        #
        # class Foo(object):
        #     def do_stuff(self):
        #         ....
        # class Bar(Foo):
        #     def do_stuff(self):
        #         ....
        #
        # you get a tags file that lists two do_stuff tags with the same
        # search pattern:
        #
        # do_stuff	foo.py	/^    def do_stuff(self):$/;"	m	class:Foo
        # do_stuff	foo.py	/^    def do_stuff(self):$/;"	m	class:Bar
        #
        # and when you :2tag clean you end up in the same place as you do
        # when you :tag clean -- on Foo.do_stuff, because it's 1st.
        #
        # So here's a workaround: first find the right class, then find
        # the right method in that class.
        debug("Applying Python class method workaround")
        command("keepjumps 0;/^class %s\>/;%s" % (tag['class'], tag["cmd"]))
    else:
        command("keepjumps 0;%s" % tag['cmd'])

END

fun! Tag(name)
    py smart_tag_jump(vim.eval('a:name'))
endf

command! -nargs=1 -complete=tag -bar Tag :call Tag(<f-args>)
