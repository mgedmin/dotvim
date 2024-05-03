extensions :=
extensions += command-t
##extensions += ycm		<- I've disabled YouCompleteMe

command_t_ext := bundle/command-t/ruby/command-t/ext/command-t/ext.so
command_t_clean := bundle/command-t/ruby/command-t/ext/command-t/*.o
ycm_ext := bundle/YouCompleteMe/python/ycm_core.so bundle/YouCompleteMe/python/ycm_client_support.so

# user config file symlinks to set up with 'make install'
install := ~/.vimrc ~/.config/nvim

.PHONY: all
all: $(install) vim-plug $(extensions)

.PHONY: help
help:
	@echo 'make                     # initial setup after fresh checkout'
	@echo 'make help                # show this help message'
	@echo 'make install             # install missing plugins'
	@echo "make update              # update all plugins to latest version"
	@echo "make update-vim-plug     # update the plugin manager"
	@echo 'make rebuild             # recompile extensions (e.g. after distro upgrade)'

.PHONY: install
install bundle/command-t: | vim-plug
	vim +PlugInstall

.PHONY: update
update: vim-plug
	vim +PlugUpdate

.PHONY: rebuild
rebuild:
	rm -f $(command_t_ext) $(command_t_clean) $(ycm_ext)
	@make -s all

.PHONY: vim-plug
vim-plug: autoload/plug.vim
autoload/plug.vim:
	@make -s update-vim-plug

.PHONY: update-vim-plug
update-vim-plug:
	curl -fLo $@ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

.PHONY: command-t
command-t: $(command_t_ext)
$(command_t_ext): | bundle/command-t
	# You may need to apt-get install ruby ruby-dev if this fails:
	cd bundle/command-t/ruby/command-t/ext/command-t \
	    && ruby extconf.rb \
	    && make

.PHONY: ycm
ycm: $(ycm_ext)
$(ycm_ext): | bundle/YouCompleteMe
	# You may need to apt-get install cmake if this fails:
	cd bundle/YouCompleteMe && ./install.sh

~/.vimrc:
	ln -sr vimrc ~/.vimrc

~/.config/nvim:
	ln -sr . ~/.config/nvim
