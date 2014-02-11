all: bundle/vundle command-t ycm

install bundle/command-t bundle/YouCompleteMe: bundle/vundle
	vim +BundleInstall
	@touch -c bundle/command-t bundle/YouCompleteMe

update: bundle/vundle
	vim +BundleInstall!

bundle/vundle:
	git clone https://github.com/gmarik/vundle.git bundle/vundle

command-t: bundle/command-t/ruby/command-t/ext.so
bundle/command-t/ruby/command-t/ext.so:
	@make -s bundle/command-t
	# You may need to apt-get install ruby ruby-dev if this fails:
	cd bundle/command-t/ruby/command-t/ && ruby extconf.rb && make

ycm: bundle/YouCompleteMe/python/ycm_core.so bundle/YouCompleteMe/python/ycm_client_support.so
bundle/YouCompleteMe/python/ycm_core.so bundle/YouCompleteMe/python/ycm_client_support.so:
	@make -s bundle/YouCompleteMe
	# You may need to apt-get install cmake if this fails:
	cd bundle/YouCompleteMe && ./install.sh
