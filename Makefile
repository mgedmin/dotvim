extensions :=
extensions += command-t
##extensions += ycm		<- I've disabled YouCompleteMe

command_t_ext := bundle/command-t/ruby/command-t/ext/command-t/ext.so
ycm_ext := bundle/YouCompleteMe/python/ycm_core.so bundle/YouCompleteMe/python/ycm_client_support.so

.PHONY: all
all: ~/.vimrc vim-plug $(extensions)

.PHONY: help
help:
	@echo 'make all     - fetch all plugins and compile after a fresh checkout'
	@echo 'make install - install missing plugins'
	@echo "make update  - update all plugins"
	@echo 'make rebuild - recompile plugins (e.g. after distro upgrade)'

.PHONY: install
install bundle/command-t: | vim-plug
	vim +PlugInstall

.PHONY: update
update: vim-plug
	vim +PlugUpdate

.PHONY: rebuild
rebuild:
	rm -f $(command_t_ext) $(ycm_ext)
	@make -s all

.PHONY: vim-plug
vim-plug: autoload/plug.vim
autoload/plug.vim:
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
