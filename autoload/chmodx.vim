fun! chmodx#doit()
    if getline(1) =~ "^#!"
        if expand("<afile>:t") =~ "test.*py"
            return
        endif
        if expand("<afile>") =~ "://"
            return
        endif
        if expand("<afile>:p") =~ "/src/ansible/"
            return
        endif
        if getfperm(expand("<afile>")) !~ "x"
            echomsg "Making" expand("<afile>") "executable"
            silent exec '!chmod +x <afile>'
        endif
    endif
endf
