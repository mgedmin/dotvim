EXTENSIONS := 
EXTENSIONS += command-t
##EXTENSIONS += ycm		<- I've disabled YouCompleteMe

.PHONY: all
all: vim-plug $(EXTENSIONS)

.PHONY: help
help:
	@echo 'make all     - fetch all bundles and compile after a fresh checkout'
	@echo 'make install - install missing bundles'
	@echo "make update  - update all bundles (doesn't recompile)"
	@echo 'make rebuild - recompile bundles'

.PHONY: install
install bundle/command-t: | vim-plug
	vim +PlugInstall

.PHONY: update
update: vim-plug
	vim +PlugUpdate

.PHONY: rebuild
rebuild:
	rm -f bundle/command-t/ruby/command-t/*.so
	rm -f bundle/YouCompleteMe/python/*.so
	@make -s all

.PHONY: vim-plug
vim-plug: autoload/plug.vim
autoload/plug.vim:
	curl -fLo $@ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

.PHONY: command-t
command-t: bundle/command-t/ruby/command-t/ext.so
bundle/command-t/ruby/command-t/ext.so:
	@make -s bundle/command-t
	# You may need to apt-get install ruby ruby-dev if this fails:
	cd bundle/command-t/ruby/command-t/ext/command-t \
	    && ruby extconf.rb \
	    && make

.PHONY: ycm
ycm: bundle/YouCompleteMe/python/ycm_core.so bundle/YouCompleteMe/python/ycm_client_support.so
bundle/YouCompleteMe/python/ycm_core.so bundle/YouCompleteMe/python/ycm_client_support.so:
	@make -s bundle/YouCompleteMe
	# You may need to apt-get install cmake if this fails:
	cd bundle/YouCompleteMe && ./install.sh
