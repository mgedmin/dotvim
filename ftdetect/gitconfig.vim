" I include ~/.gitconfig.local from ~/.gitconfig
au BufRead,BufNewFile .gitconfig.local  set filetype=gitconfig

" ~/.gitconfig is a symlink to ~/dotfiles/gitconfig
au BufRead,BufNewFile gitconfig,gitconfig.local  set filetype=gitconfig
