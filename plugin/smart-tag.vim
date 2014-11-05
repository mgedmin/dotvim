"
" File: smart-tag.vim
" Author: Marius Gedminas <marius@gedmin.as>
" Version: 0.1
" Last Modified: 2014-11-05
"
" Smarter :tag
"
" Usage:
"   :Tag name               -- jump to a global function
"   :Tag class.name         -- jump to the right class method
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
    class_, dot, name = query.rpartition('.')
    tags = vim.eval('taglist("^%s$")' % name)
    if verbose > 0:
        print("Got %d tags for %s" % (len(tags), name))
    index = None
    if class_:
        for i, t in enumerate(tags, 1):
            if t.get("class") == class_:
                if verbose > 0:
                    print("Matching class at index %d" % (i))
                if index is None:
                    index = i
    else:
        # Look for a global function; if not found, fall back to the 1st method
        index = 1
        for i, t in enumerate(tags, 1):
            if not t.get("class"):
                if verbose > 0:
                    print("Matching function at index %d" % (i))
                if index == 1:
                    index = i
    if not tags or index is None:
        print("Couldn't find %s" % query)
    else:
        tag = tags[index-1]
        if verbose > 0:
            print(":%dtag %s" % (index, name))
        vim.command("%dtag %s" % (index, name))
        if class_ and tag['filename'].endswith('.py'):
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
            if verbose > 0:
                print("Applying Python class method workaround:")
                print("/^class %s\>/;%s" % (class_, tag["cmd"]))
            vim.command("/^class %s\>/;%s" % (class_, tag["cmd"]))

END

fun! Tag(name)
    py smart_tag_jump(vim.eval('a:name'))
endf

command! -nargs=1 -complete=tag -bar Tag :call Tag(<f-args>)
