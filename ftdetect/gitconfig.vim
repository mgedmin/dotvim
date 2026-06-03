" I include ~/.gitconfig.local and .gitconfig.personal from ~/.gitconfig
au BufRead,BufNewFile .gitconfig*   set filetype=gitconfig

" ~/.gitconfig is a symlink to ~/dotfiles/gitconfig
au BufRead,BufNewFile gitconfig*    set filetype=gitconfig
