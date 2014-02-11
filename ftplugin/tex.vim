" TeX/LaTeX files

" Enable wrapping
setlocal textwidth=78

" <F8> = start xdvi in background
map  <buffer> <F8>    :!xdvi %:r.dvi&<CR><C-L>
imap <buffer> <F8>    <C-O><F8>

" <F9> = process file with LaTeX
map  <buffer> <F9>    :!latex --src-specials % && killall -USR1 xdvi.bin 2>/dev/null<CR>
imap <buffer> <F9>    <C-O><F9>
" To get full benefits from --src-specials, put this in your ~/.Xresources:
"   XDvi.editor: gvim --remote +%l %f

" Abbreviations
ab \b           \begin
ab \e           \end
ab \begin{e}    \begin{enumerate}
ab \end{e}      \end{enumerate}
ab \begin{i}    \begin{itemize}
ab \end{i}      \end{itemize}
ab \begin{a}    \begin{align*}
ab \end{a}      \end{align*}
ab \begin{eq}   \begin{equation}
ab \end{eq}     \end{equation}

ab \i           \item
ab \d           \documentclass[a4paper]{article}
ab \D           \Def
ab \f           \frac
ab {\f          {\frac
ab (\f          (\frac
ab )\f          )\frac
ab -\f          -\frac
