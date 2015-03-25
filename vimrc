" ~/.vim/vimrc by Marius Gedminas <marius@gedmin.as>
"
" I've tried to make it work with vim.tiny without errors, by sprinkling
" conditionals all over the place.
"

"
" Options                                                       {{{1
"
set nocompatible                " be sane (default if you have a .vimrc)

" Presentation                                                  {{{2
set laststatus=2                " always show a status line
set cmdheight=2                 " avoid 'Press ENTER to continue'
set guioptions-=L               " disable left scrollbar in GUI
set guioptions-=m               " disable GUI menu
set showcmd                     " show partial commands in status line
set ruler                       " show cursor position in status line
set list                        " show tabs and spaces at end of line:
set listchars=tab:>-,trail:.,extends:>
if v:version >= 600
  set listchars+=precedes:<
endif
if v:version >= 700
  set listchars+=nbsp:_
endif
if has("linebreak")
  let &sbr = nr2char(8618).' '  " Show ↪ at the beginning of wrapped lines
endif
if has("extra_search")
  set hlsearch                  " highlight search matches
  nohlsearch                    " but not initially
endif
if v:version >= 703
  set colorcolumn=81            " highlight column 81
  let &colorcolumn=join(range(81,999),",") " and columns after that
endif

" I want gvim to look the same as vim in gnome-terminal
set guifont=Ubuntu\ Mono\ 13

" Silence                                                       {{{2
set noerrorbells                " don't beep!
set visualbell                  " don't beep!
set t_vb=                       " don't beep! (but also see below)

" Interpreting file contents                                    {{{2
set modelines=5                 " debian disables this by default
set fileencodings=ucs-bom,utf-8,windows-1252,iso-8859-13,latin1 " autodetect
        " Vim cannot distinguish between 8-bit encodings, so the last two
        " won't ever be considered.  I keep them here for convenience:
        " :set fencs=<tab>, then delete the ones you don't want

" Backup files                                                  {{{2
set backup                      " make backups
set backupdir=~/tmp             " but don't clutter $PWD with them

if $USER == "root"
  " 'sudo vi' on certain machines cannot write to ~/tmp (NFS root-squash)
  set backupdir=/root/tmp
endif

if !isdirectory(&backupdir)
  " create the backup directory if it doesn't already exist
  exec "silent !mkdir -p " . &backupdir
endif

" Avoiding excessive I/O                                        {{{2
set swapsync=                   " be more friendly to laptop mode (dangerous)
                                " this could result in data loss, so beware!
if v:version >= 700
  set nofsync                   " be more friendly to laptop mode (dangerous)
                                " this could result in data loss, so beware!
endif

" Behaviour                                                     {{{2
set wildmenu                    " nice tab-completion on the command line
set wildmode=longest,full       " nicer tab-completion on the command line
set hidden                      " side effect: undo list is not lost on C-^
set browsedir=buffer            " :browse e starts in %:h, not in $PWD
set autoread                    " automatically reload files changed on disk
set history=1000                " remember more lines of cmdline history
set switchbuf=useopen           " quickfix reuses open windows
set iskeyword-=/                " Ctrl-W in command-line stops at /

if has('mouse_xterm')
  set mouse=a                   " use mouse in xterms
endif

if v:version >= 600
  set clipboard=unnamed         " interoperate with the X clipboard
  set splitright                " self-explanatory
endif

if v:version >= 700
  set diffopt+=vertical         " split diffs vertically
  set spelllang=en,lt           " spell-check two languages at once
endif

" Input                                                         {{{2

set timeoutlen=1000 ttimeoutlen=20 " timeout keys after 20ms, mappings after 1s
                                " doesn't seem to work for <esc>Ok

" Movement                                                      {{{2
set incsearch                   " incremental searching
set scrolloff=2                 " always keep cursor 2 lines from screen edge
set nostartofline               " don't jump to start of line

" Folding                                                       {{{2
if v:version >= 600
" set foldmethod=marker         " use folding by markers by default
  set foldlevelstart=9999       " initially open all folds
endif

" Editing                                                       {{{2
set backspace=indent,eol,start  " sane backspacing
set nowrap                      " do not wrap long lines
set shiftwidth=4                " more-or-less sane indents
set softtabstop=4               " make the <tab> key more useful
set tabstop=8                   " anything else is heresy
set expandtab                   " sane default
set noshiftround                " do NOT enforce the indent
set autoindent                  " automatic indent
set nosmartindent               " but no smart indent (ain't smart enough)
set isfname-=\=                 " fix filename completion in VAR=/path
if v:version >= 704
  set fo+=j                     " remove comment leader when joining lines
endif

" Editing code                                                  {{{2
set path+=/usr/include/i386-linux-gnu   " multiarch on ubuntu
set path+=/usr/include/x86_64-linux-gnu " multiarch on ubuntu
set path+=**                    " let :find do recursive searches
set tags-=./TAGS                " ignore emacs tags to prevent duplicates
set tags-=TAGS                  " ignore emacs tags to prevent duplicates
set tags-=./tags                " bin/tags is not a tags file
set tags+=tags;$HOME            " look for tags in parent dirs
set suffixes+=.class            " ignore Java class files
set suffixes+=.pyc,.pyo         " ignore compiled Python files
set suffixes+=.egg-info         " ignore compiled Python files
set suffixes+=.~1~,.~2~         " ignore Bazaar droppings
set wildignore+=*.pyc,*.pyo     " same as 'suffixes', but for tab completion
set wildignore+=*.o,*.d,*.so    " same as 'suffixes', but for tab completion
set wildignore+=*.egg-info/**   " same as 'suffixes', but for tab completion
set wildignore+=*~              " same as 'suffixes', but for tab completion
set wildignore+=local/**        " virtualenv
set wildignore+=build/**        " distutils, I hates them
set wildignore+=dist/**         " distutils deliverables
set wildignore+=htmlcov/**      " coverage.py
set wildignore+=coverage/**     " zope.testrunner --coverage
set wildignore+=parts/omelette/** " collective.recipe.omelette
set wildignore+=parts/**        " all buildout-generated junk even
set wildignore+=lib/**          " virtualenv
set wildignore+=eggs/**         " virtualenv
set wildignore+=.tox/**         " tox
set wildignore+=_build/**       " sphinx
set wildignore+=python/**       " virtualenv called 'python'
set wildignore+=__pycache__/**  " compiled python files

if v:version >= 700
  set complete-=i               " don't autocomplete from included files (too slow)
  set completeopt-=preview      " don't show the preview window
endif

" Python tracebacks (unittest + doctest output)                 {{{2
set errorformat&
set errorformat+=
            \File\ \"%f\"\\,\ line\ %l%.%#,
            \%C\ %.%#,
            \%-A\ \ File\ \"unittest%.py\"\\,\ line\ %.%#,
            \%-A\ \ File\ \"%f\"\\,\ line\ 0%.%#,
            \%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,
            \%Z%[%^\ ]%\\@=%m

" Shell scripts                                                 {{{2
if has("eval")
  let g:is_posix = 1            " /bin/sh is POSIX, not ancient Bourne shell
  let g:sh_fold_enabled = 7     " fold functions, heredocs, ifs/loops
endif

" Persistent undo (vim 7.3+)                                    {{{2
if has("persistent_undo")
  set undofile                  " enable persistent undo
  let &undodir=&backupdir . "/.vimundo" " but don't clutter $PWD
  if !isdirectory(&undodir)
    " create the undo directory if it doesn't already exist
    exec "silent !mkdir -p " . &undodir
  endif
endif

" Netrw explorer                                                {{{2
if has("eval")
  let g:netrw_keepdir = 1                       " does not work!
  let g:netrw_list_hide = '.*\.swp\($\|\t\),.*\.py[co]\($\|\t\)'
  let g:netrw_sort_sequence = '[\/]$,*,\.bak$,\.o$,\.h$,\.info$,\.swp$,\.obj$,\.py[co]$'
  let g:netrw_timefmt = '%Y-%m-%d %H:%M:%S'
  let g:netrw_use_noswf = 1                     " this is default AFAIU so ?
endif

"
" Plugins                                                       {{{1
"

" Vundle                                                        {{{2
"
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" read documentation at https://github.com/gmarik/vundle#readme
if has("user_commands")
  set rtp+=~/.vim/bundle/vundle/
  runtime autoload/vundle.vim " apparently without this the exists() check fails
endif
if exists("*vundle#begin")
  filetype off
  call vundle#begin()

  " install/upgrade vundle itself (there's the obvious chicken and egg problem
  " here); if vundle is missing, bootstrap it with
  "   git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  Plugin 'gmarik/vundle'

  " list all plugins you want to have like this:
  "   Plugin 'foo.vim' for vim.org-hosted stuff
  "   Plugin 'owner/project' for github-hosted stuff
  "   Plugin 'git://git.wincent.com/command-t.git' for arbitrary URLs
  " install ones that are missing with :PluginInstall
  " install/upgrade them all with :PluginInstall!
  " search for new ones with :PluginSearch keyword
  " bundles are kept in ~/.vim/bundle/

  " Show [current_function] in the status line for C files
  Plugin 'mgedmin/chelper.vim'

  " Show [CurrentClass.current_method] in the status line for Python files
  Plugin 'mgedmin/pythonhelper.vim'

  " Automate 'from X import Y' statements from ctags, bound to <F5>
  Plugin 'mgedmin/python-imports.vim'

  " Better Python autoindentation
  Plugin 'hynek/vim-python-pep8-indent'

  " Automate switching between code and unit test files, bound to <C-F6>
  Plugin 'mgedmin/test-switcher.vim'

  " Open files by typing a subsequence of the pathname, bound to \t
  Plugin 'git://git.wincent.com/command-t.git'
  " NB: Vundle doesn't install command-t completely automatically; you have
  " to manually do this:
  "   cd ~/.vim/bundle/command-t/ruby/command-t/ && ruby extconf.rb && make
  " you might also need some packages installed, like build-essential and
  " ruby1.8-dev

  " pure-python alternative to command-t, slightly different UI, not as nice
  " to use as command-t but useful for some circumstances.  Bound to <C-P>
  Plugin 'ctrlp.vim'

  " Show syntax errors and style warnings in files I edit.  Updates on save.
  Plugin 'scrooloose/syntastic'

  " Show ASCII-art representation of Vim's undo tree, with bonus unified diffs
  Plugin 'Gundo'

  " Defines the very useful :Rename newfilename.txt
  Plugin 'Rename'

  " Git integration -- :Gdiff, :Ggrep etc.
  Plugin 'tpope/vim-fugitive'
  " Plugin 'fugitive.vim' -- 2-years old version of tpope/vim-fugitive

  " Version control integration for SVN and other legacy VCSes -- :VCSVimDiff
  Plugin 'vcscommand.vim'

  " Load previous svn-commit.tmp automatically when you repeat 'svn ci' after
  " a failed commit.
""  Plugin 'svn_commit.vim'  404 not found, I must've misspelled

  " Show the svn diff while I'm editing an svn commit message.
  Plugin 'svn-diff.vim'

  " LESS (the CSS preprocessor) syntax
  Plugin 'groenewege/vim-less'

  " List open buffers with various sorting modes on \b
  Plugin 'jlanzarotta/bufexplorer'

  " ^P/^N completion on the command line
  Plugin 'CmdlineComplete'

  " Replace 'ga' to show Unicode names etc.
  Plugin 'tpope/vim-characterize'

  " Snippets!  Type some text, press <tab> to expand, with get expansion with
  " multiple placeholders you can keep or replace and tab over.
  " Supposedly better than SnipMate which I used earlier.  Integrates with
  " YouCompleteMe
  Plugin 'SirVer/UltiSnips'

  " Default snippet collection
  Plugin 'honza/vim-snippets'

  " Smart omni-completion for everything.  I've disabled most of it because it
  " was making my life actually harder instead of easier.  And then I disabled
  " it completely because it was just costing me 100ms of startup time for
  " practically no benefit.  Plus, sudo vim foo -> a Python web server running
  " as root == eek
""if v:version >= 704 || v:version == 703 && has("patch584")
""  " YouCompleteMe needs vim 7.3.584 or newer
""  Plugin 'Valloric/YouCompleteMe'
""  " It needs extra install:
""  "   cd ~/.vim/bundle/YouCompleteMe && ./install.sh
""endif

  " Smart omni-completion for Python
  " Disabled because Is too smart for its own good, and makes completion
  " worse, not better, for the codebases I work with.
  " Also, YouCompleteMe subsumes it.
""Plugin 'davidhalter/jedi-vim'

  " Replacement for netrw, some like it
  " Disabled because it takes over netrw windows on WinEnter,  breaks Ctrl-^
""Plugin 'troydm/easytree.vim'

  " Automatically detect pasting in compatible xterms
  Plugin 'ConradIrwin/vim-bracketed-paste'

  " Create/browse/edit gists
  Plugin 'mattn/webapi-vim'
  Plugin 'mattn/gist-vim'

  " Improved ReStructuredText syntax
  Plugin 'mrsipan/vim-rst'

  " Enable vim filename:lineno and :e filename:lineno
  Plugin 'kopischke/vim-fetch'

  " xchat log syntax highlighting (set ft=xchatlog)
  Plugin 'xchat-log-syntax'
  " there's also 'XChat-IRC-Log' (set ft=irclog), but I haven't evaluated it

  call vundle#end()
  filetype plugin indent on
endif

" Filetype plugins                                              {{{2
if v:version >= 600
  filetype plugin on            " load filetype plugins
  filetype indent on            " load indent plugins
endif

" Syntastic                                                     {{{2

if has("eval")
  let g:syntastic_check_on_open = 1             " default is 0
  let g:syntastic_enable_signs = 1              " default is 1
  let g:syntastic_enable_baloons = 1            " default is 1
  let g:syntastic_enable_highlighting = 1       " default is 1
  let g:syntastic_auto_jump = 0                 " default is 0
  let g:syntastic_auto_loc_list = 2             " default is 2
  let g:syntastic_always_populate_loc_list = 1  " default is 0
" let g:syntastic_quiet_warnings = 1

  " I don't know what syntastic uses to check Java, but it's unusably slow
  let g:syntastic_mode_map = { "mode": "active",
              \ "active_filetypes": [],
              \ "passive_filetypes": ["java"] }

  " statusline format (default: '[Syntax: line:%F (%t)]')
  let g:syntastic_stl_format = '{%t}'

  " fun with unicode
  let g:syntastic_error_symbol = '⚡'
  let g:syntastic_warning_symbol = '⚠'

  " For forcing the use of flake8, pyflakes, or pylint set
" let g:syntastic_python_checkers = ['pyflakes']
  let g:syntastic_python_checkers = ['flake8']
  let $PYFLAKES_DOCTEST = ''

  let g:syntastic_javascript_checkers = ['jshint']
endif

" Command-t                                                     {{{2

if has("eval")
  let g:CommandTCursorEndMap = ['<C-e>', '<End>']
  let g:CommandTCursorStartMap = ['<C-a>', '<Home>']
  let g:CommandTMaxHeight = 20
endif

" bufexplorer.vim                                               {{{2

if has("eval")
  let g:bufExplorerShowRelativePath=1
  let g:bufExplorerSplitOutPathName=0
endif

" easytree.vim                                                  {{{2

if has("eval")
  let g:easytree_suppress_load_warning = 1
  let g:easytree_ignore_files = ['*.sw[po]', '*.py[co]']
endif

" YouCompleteMe                                                 {{{2

if has("eval")
  " auto-triggering breaks typing-then-<Up>/<Down> navigation in insert mode
  " auto-triggering also breaks foo<C-p> completion
  let g:ycm_auto_trigger = 0
  " so I'm confused: I'd think I'd want this, but it appears to already
  " detect my tags, despite the docs saying this is off by default?
  " eh, maybe I had the right buffers open at that time.
  " BTW apparently I need ctags --fields=+l for YCM to work
  ""let g:ycm_collect_identifiers_from_tags_files = 1
  " I hate when the preview window stays on screen
  let g:ycm_autoclose_preview_window_after_completion = 1
  " don't stomp on the <Tab> key dammit
  let g:ycm_key_list_select_completion = ['<Down>']
  let g:ycm_key_list_previous_completion = ['<Up>']
endif

" UltiSnips                                                     {{{2

if has("eval")
  " don't override ^J/^K -- I don't mind ^J, but ^K is digraphs
  let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
  " <c-tab> doesn't work in gnome-terminal
  let g:UltiSnipsListSnippets="<C-R><tab>"
endif

" Manual pages (:Man foo)                                       {{{2
if v:version >= 600
  runtime ftplugin/man.vim
endif

" Toggle between .c (.cc, .cpp) and .h                          {{{2
" ToggleHeader defined in $HOME/.vim/plugin/cpph.vim

" Maybe these mappings should be moved into FT_C() ?
map             ,h              :call ToggleHeader()<CR>
map             <C-F6>          ,h
imap            <C-F6>          <C-O><C-F6>

" List all functions in a file                                  {{{2
" functions defined in $HOME/.vim/plugin/funcs.vim

" Maybe these mappings should be moved into FT_C() ?
map             ,l              :call ListAllFunctions(1)<CR>
map             ,j              :<C-U>call JumpToFunction(0)<CR>

" Python syntax highligting                                     {{{2
" from http://hlabs.spb.ru/vim/python.vim
if has("eval")
  let python_highlight_all = 1
  let python_slow_sync = 1
endif

" py-test-runner.vim                                            {{{2

map             ,t              :CopyTestUnderCursor<cr>

if has("user_commands")
  " :Co now expands to :CommandT, but I'm used to type it as a shortcut for
  " :CopyTestUnderCursor
  command! Co CopyTestUnderCursor
endif

" XML syntax folding                                            {{{2
if has("eval")
  let xml_syntax_folding = 1
endif

" XML tag complyetion                                           {{{2
if has("eval")
  " because autocompleting when I type > is irritating half of the time
  let xml_tag_completion_map = "<C-l>"
endif

" VCSCommand configuration                                      {{{2
if has("eval")
  " I want 'edit' for VCSAnnotate, but 'split' for all others :(
  let VCSCommandEdit = 'split'
  let VCSCommandDeleteOnHide = 1
  let VCSCommandCommitOnWrite = 0
endif

" git ftplugin                                                  {{{2
if has("eval")
  let git_diff_spawn_mode = 1
endif

" bzr syntax plugin                                             {{{2
if has("eval")
  " NB: it uses an exists() check, so don't set it to 0 if you want it off
  let bzr_highlight_diff = 1
endif

" surround.vim                                                  {{{2
" make it not clobber 's' in visual mode
vmap <Leader>s <Plug>Vsurround
vmap <Leader>S <Plug>VSurround

" NERD_tree.vim                                                 {{{2
if v:version >= 700 && has("eval")
  let g:NERDTreeIgnore = ['\.pyc$', '\~$']
  let g:NERDTreeHijackNetrw = 0
endif

" jedi.vim                                                      {{{2
if has("eval")
  " show_function_definition is a hack that modified your source buffer
  " and interacts badly with syntax highlighting
  let g:jedi#show_function_definition = "0"
  " I type 'import zope.component', I see 'import zope.interfacecomponent'
  " because jedi autocompletes the only zope subpackage it finds in
  " site-packages, unmindful about my virtualenvs/buildouts.
  let g:jedi#popup_select_first = 0
endif

"
" Status line                                                   {{{1
"

" I need to do this _after_ setting plugin options, since my statusline
" relies on functions defined in some plugins, so I want to try to source
" those plugins early to check if I need to define fallback functions, in
" case those plugins are unavailable.

" To emulate the standard status line with 'ruler' set, use this:
"
"   set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"
" I've tweaked it a bit to show the buffer number on the left, and the total
" number of lines on the right.  Also, show the current Python function in the
" status line, if the pythonhelper.vim plugin exists and can be loaded.

runtime plugin/pythonhelper.vim
runtime plugin/chelper.vim
if !exists("*TagInStatusLine")
  function TagInStatusLine()
    return ''
  endfunction
endif
if !exists("*CTagInStatusLine")
  function CTagInStatusLine()
    return ''
  endfunction
endif

runtime plugin/syntastic.vim
if !exists("*SyntasticStatuslineFlag")
  function! SyntasticStatuslineFlag()
    return ''
  endfunction
endif

if !exists("*haslocaldir")
  function! HasLocalDir()
    return ''
  endfunction
else
  function! HasLocalDir()
    if haslocaldir()
      return '[lcd]'
    endif
    return ''
  endfunction
endif

set statusline=                 " my status line contains:
set statusline+=%n:             " - buffer number, followed by a colon
set statusline+=%<%f            " - relative filename, truncated from the left
set statusline+=\               " - a space
set statusline+=%h              " - [Help] if this is a help buffer
set statusline+=%m              " - [+] if modified, [-] if not modifiable
set statusline+=%r              " - [RO] if readonly
set statusline+=%2*%{HasLocalDir()}%*           " [lcd] if :lcd has been used
set statusline+=%#error#%{SyntasticStatuslineFlag()}%*
set statusline+=\               " - a space
set statusline+=%1*%{TagInStatusLine()}%*       " [current class/function]
set statusline+=%1*%{CTagInStatusLine()}%*      " same but for C code
set statusline+=\               " - a space
set statusline+=%=              " - right-align the rest
set statusline+=%-10.(%l:%c%V%) " - line,column[-virtual column]
set statusline+=\               " - a space
" it doesn't fit on my 1388x768 screen when I use vertical splits
" and have [LongClassName.long_method_name] tags :/
""set statusline+=%4L           " - total number of lines in buffer
""set statusline+=\             " - a space
set statusline+=%P              " - position in buffer as percentage

" Other notes:
"   %1*         -- switch to highlight group User1
"   %{}         -- embed the output of a vim function
"   %*          -- switch to the normal highlighting
"   %=          -- right-align the rest
"   %-10.(...%) -- left-align the group inside %(...%)


"
" Commands                                                      {{{1
"

if has("user_commands")

" like :Explore, only never split windows                       {{{2
command! E :e %:p:~:.:h

" how many occurrences of the current search pattern?           {{{2
command! -range=% CountMatches          <line1>,<line2>s///n

" die, trailing whitespace! die!                                {{{2
command! -range=% NukeTrailingWhitespace <line1>,<line2>s/\s\+$//

" where's that non-ascii character?                             {{{2
command! FindNonAscii                   normal /[^\x00-\x7f]<cr>
command! FindControlChars               normal /[\x00-\x08\x0a-\x1f\x7f]<cr>

" diffoff sets wrap; don't wanna                                {{{2
command! Diffoff                        diffoff | setlocal nowrap

" See :help DiffOrig                                            {{{2
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                  \ | wincmd p | diffthis

" :Time SomeOtherCommand                                        {{{2
command! -nargs=+ -complete=command Time
            \ let start = reltime() |
            \ exec <q-args> |
            \ echomsg reltimestr(reltime(start)) . " seconds"

" svncommand aliases that I'm used to                           {{{2
command! -nargs=* SVNAdd                VCSAdd <args>
command! -nargs=* SVNBlame              VCSAnnotate <args>
command! -nargs=? -bang SVNCommit       VCSCommit<bang> <args>
command! -nargs=* SVNDiff               VCSDiff <args>
command! -nargs=* SVNLog                VCSLog <args>
command! -nargs=0 SVNRevert             VCSRevert <args>
command! -nargs=* SVNStatus             VCSStatus <args>
command! -nargs=0 SVNUpdate             VCSUpdate <args>
command! -nargs=* SVNVimDiff            VCSVimDiff <args>

command! -nargs=* BZRVimDiff            VCSVimDiff <args>

" :CW                                                           {{{2
command! CW             botright cw

" :W is something I accidentally type all the time              {{{2
command! W              w

" :Gundo is easy to tab-complete but isn't an actual command!   {{{2
command! Gundo          GundoShow

" Highlight group debugging                                     {{{2
function! s:SynAttrs(id)
  return ""
    \ . (synIDattr(a:id, "font") != "" ? ' font:' . synIDattr(a:id, "font") : "")
    \ . (synIDattr(a:id, "fg") != ""  ? ' fg:' . synIDattr(a:id, "fg") : "")
    \ . (synIDattr(a:id, "bg") != ""  ? ' bg:' . synIDattr(a:id, "bg") : "")
    \ . (synIDattr(a:id, "sp") != ""  ? ' sp:' . synIDattr(a:id, "sp") : "")
    \ . (synIDattr(a:id, "bold") ? " bold" : "")
    \ . (synIDattr(a:id, "italic") ? " italic" : "")
    \ . (synIDattr(a:id, "reverse") ? " reverse" : "")
    \ . (synIDattr(a:id, "standout") ? " standout" : "")
    \ . (synIDattr(a:id, "underline") ? " underline" : "")
    \ . (synIDattr(a:id, "undercurl") ? " undercurl" : "")
endf
function! s:ShowHighlightGroup()
  let hi = synID(line("."), col("."), 1)
  let trans = synID(line("."), col("."), 0)
  let lo = synIDtrans(hi)
  " In my experiments s:SynAttrs() always returns "" for hi and trans
  echo "hi<" . synIDattr(hi, "name") . '>'
    \ . s:SynAttrs(hi)
    \ . ' trans<' . synIDattr(trans, "name") . '>'
    \ . s:SynAttrs(trans)
    \ . ' lo<' . synIDattr(lo, "name") . '>'
    \ . s:SynAttrs(lo)
endf
function! s:ShowSyntaxStack()
  for id in synstack(line("."), col("."))
    echo printf("%-20s %s", synIDattr(id, "name"), s:SynAttrs(synIDtrans(id)))
  endfor
endf
command! ShowHighlightGroup call s:ShowHighlightGroup()
command! ShowSyntaxStack call s:ShowSyntaxStack()

" :Margin n -- highlight columns beyond n                       {{{2
" :Margin   -- show the current highlight margin

function! s:Margin(...)
  if a:0
    let &colorcolumn=join(range(a:1+1,999),",")
  else
    echo min(split(&colorcolumn, ',')) - 1
  endif
endf
command! -nargs=? -bar Margin  call s:Margin(<args>)

" :NoLCD                                                        {{{2
command! NoLCD          exe 'cd '.getcwd()

" :EditSnippets for UltiSnips                                   {{{2
command! -nargs=? EditSnippets
  \ exe ":e ~/.vim/UltiSnips/".(<q-args> != "" ? <q-args> : &ft != "" ? &ft : "all").".snippets"

" :Python3 and :Python2 to toggle Syntastic/flake8 mode         {{{2

command! -bar Python2 let g:syntastic_python_flake8_exe = 'python2 -m flake8' | SyntasticCheck
command! -bar Python3 let g:syntastic_python_flake8_exe = 'python3 -m flake8' | SyntasticCheck

endif " has("user_commands")

"
" Keyboard macros                                               {{{1
"

" Ctrl-L loads changed files, updates diff, recomputes folds    {{{2

noremap         <C-L>           :checktime<bar>diffupdate<CR>zx<C-L>

" Alt-. inserts last word from previous line                    {{{2

inoremap        <Esc>.          <C-R>=split(getline(line(".")-1))[-1]<CR>

" Ctrl-_ toggles the presence of _ in 'iskeyword'               {{{2
" Sometimes this improves tab completion -- when I write a new
" test and want to name it test_ClassName_methodname()

if has("eval")
  fun! ToggleUnderscoreInKeywords()
    if &isk =~ '_'
       set isk-=_
       echo "_ is not a keyword character"
    else
        set isk+=_
       echo "_ is a keyword character"
    endif
    return ''
  endf
endif

noremap         <C-_>           :call ToggleUnderscoreInKeywords()<CR>
inoremap        <C-_>           <C-R>=ToggleUnderscoreInKeywords()<CR>

" Digraphs                                                      {{{2

if has("digraphs")
  digraph -- 8212               " em dash
  digraph `` 8220               " left double quotation mark
  digraph '' 8221               " right double quotation mark
  digraph ,, 8222               " double low-9 quotation mark
endif

" Remember columns when jumping to marks                        {{{2
map             '               `

" Undo in insert mode                                           {{{2
" make it so that if I accidentally press ^W or ^U in insert mode,
" then <ESC>u will undo just the ^W/^U, and not the whole insert
" This is documented in :help ins-special-special, a few pages down
inoremap <C-W> <C-G>u<C-W>
inoremap <C-U> <C-G>u<C-U>

" The same applies for accidentally pasting the wrong thing while in insert
" mode: you don't want u to undo the text you typed before you mispasted
inoremap <MiddleMouse> <C-G>u<MiddleMouse>

" */# search in visual mode (from www.vim.org)                  {{{2

" Atom \V sets following pattern to "very nomagic", i.e. only the backslash
" has special meaning.
" As a search pattern we insert an expression (= register) that
" calls the 'escape()' function on the unnamed register content '@@',
" and escapes the backslash and the character that still has a special
" meaning in the search command (/|?, respectively).
" This works well even with <Tab> (no need to change ^I into \t),
" but not with a linebreak, which must be changed from ^M to \n.
" This is done with the substitute() function.
" See http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap * y/\V<C-R>=substitute(escape(@@,"/\\"),"\n","\\\\n","ge")<CR><CR>
vnoremap # y?\V<C-R>=substitute(escape(@@,"?\\"),"\n","\\\\n","ge")<CR><CR>

" Sane 'all string' text object                                 {{{2

omap            a'              2i'
omap            a"              2i"
vmap            a'              2i'
vmap            a"              2i"

" Diffget/diffput in visual mode                                {{{2

vmap            \do             :diffget<CR>
vmap            \dp             :diffput<CR>

" S-Insert pastes                                               {{{2
map!            <S-Insert>      <MiddleMouse>

" .vimrc editing                                                {{{2
set wildcharm=<C-Z>
map             ,e              :e $HOME/.vim/vimrc<CR>
map             ,s              :source $HOME/.vim/vimrc<CR>
map             ,PE             :e $HOME/.vim/plugin/<C-Z><C-Z>
map             ,IE             :e $HOME/.vim/indent/<C-Z><C-Z>
map             ,FE             :e $HOME/.vim/ftplugin/<C-Z><C-Z>
map             ,XE             :e $HOME/.vim/syntax/<C-Z><C-Z>

" double comma for limited virtual keyboards                    {{{2
map             ,,              :update<CR>
imap            ,,              <ESC>

" open a file in the same dir as the current one                {{{2
map <expr>      ,E              ":e ".expand("%:h")."/"

" open a file with same basename but different extension        {{{2
map <expr>      ,R              ":e ".expand("%:r")."."

" close just the deepest level of folds                         {{{2
map             ,zm             zMzRzm

" Scrolling with Ctrl+Up/Down                                   {{{2
map             <C-Up>          1<C-U>
map             <C-Down>        1<C-D>
imap            <C-Up>          <C-O><C-Up>
imap            <C-Down>        <C-O><C-Down>

" Scrolling with Ctrl+Shift+Up/Down                             {{{2
map             <C-S-Up>        1<C-U><Down>
map             <C-S-Down>      1<C-D><Up>
imap            <C-S-Up>        <C-O><C-S-Up>
imap            <C-S-Down>      <C-O><C-S-Down>

" Moving around with Shift+Up/Down                              {{{2
map             <S-Up>          {
map             <S-Down>        }
imap            <S-Up>          <C-O><S-Up>
imap            <S-Down>        <C-O><S-Down>

" Navigating around windows
map             <C-W><C-Up>     <C-W><Up>
map             <C-W><C-Down>   <C-W><Down>
map             <C-W><C-Left>   <C-W><Left>
map             <C-W><C-Right>  <C-W><Right>
map             <C-S-Up>        <C-W><Up>
map             <C-S-Down>      <C-W><Down>
map             <C-S-Left>      <C-W><Left>
map             <C-S-Right>     <C-W><Right>
map!            <C-S-Up>        <C-O><C-W><Up>
map!            <C-S-Down>      <C-O><C-W><Down>
map!            <C-S-Left>      <C-O><C-W><Left>
map!            <C-S-Right>     <C-O><C-W><Right>

" Switching tabs with Alt-1,2,3 in gvim                         {{{2
map             <A-1>           1gt
map             <A-2>           2gt
map             <A-3>           3gt
map             <A-4>           4gt
map             <A-5>           5gt
map             <A-6>           6gt
map             <A-7>           7gt
map             <A-8>           8gt
map             <A-9>           9gt
imap            <A-1>           <C-O><A-1>
imap            <A-2>           <C-O><A-2>
imap            <A-3>           <C-O><A-3>
imap            <A-4>           <C-O><A-4>
imap            <A-5>           <C-O><A-5>
imap            <A-6>           <C-O><A-6>
imap            <A-7>           <C-O><A-7>
imap            <A-8>           <C-O><A-8>
imap            <A-9>           <C-O><A-9>
" and in terminal vim
map             <Esc>1          <A-1>
map             <Esc>2          <A-2>
map             <Esc>3          <A-3>
map             <Esc>4          <A-4>
map             <Esc>5          <A-5>
map             <Esc>6          <A-6>
map             <Esc>7          <A-7>
map             <Esc>8          <A-8>
map             <Esc>9          <A-9>
map!            <Esc>1          <A-1>
map!            <Esc>2          <A-2>
map!            <Esc>3          <A-3>
map!            <Esc>4          <A-4>
map!            <Esc>5          <A-5>
map!            <Esc>6          <A-6>
map!            <Esc>7          <A-7>
map!            <Esc>8          <A-8>
map!            <Esc>9          <A-9>
" also make alt-shift-numbers switch tabs
map             <A-!>           1gt
map             <A-@>           2gt
map             <A-#>           3gt
map             <A-$>           4gt
map             <A-%>           5gt
map             <A-^>           6gt
map             <A-&>           7gt
map             <A-*>           8gt
map             <A-(>           9gt
imap            <A-!>           <C-O><A-!>
imap            <A-@>           <C-O><A-@>
imap            <A-#>           <C-O><A-#>
imap            <A-$>           <C-O><A-$>
imap            <A-%>           <C-O><A-%>
imap            <A-^>           <C-O><A-^>
imap            <A-&>           <C-O><A-&>
imap            <A-*>           <C-O><A-*>
imap            <A-(>           <C-O><A-(>
map             <Esc>!          <A-!>
map             <Esc>@          <A-@>
map             <Esc>#          <A-#>
map             <Esc>$          <A-$>
map             <Esc>%          <A-%>
map             <Esc>^          <A-^>
map             <Esc>&          <A-&>
map             <Esc>*          <A-*>
map             <Esc>(          <A-(>
" but not in a terminal while in insert mode, because <esc>$ or <esc>^ are
" useful normal commands
""map!            <Esc>!          <A-!>
""map!            <Esc>@          <A-@>
""map!            <Esc>#          <A-#>
""map!            <Esc>$          <A-$>
""map!            <Esc>%          <A-%>
""map!            <Esc>^          <A-^>
""map!            <Esc>&          <A-&>
""map!            <Esc>*          <A-*>
""map!            <Esc>(          <A-(>

" Emacs style command line                                      {{{2
cnoremap        <C-G>           <C-C>
cnoremap        <C-A>           <Home>

" Alt+b,f move word backwards/forwards
cnoremap        <Esc>b          <S-Left>
cnoremap        <Esc>f          <S-Right>

" ^K deletes to end of line
cnoremap        <C-K>   <C-\>estrpart(getcmdline(), 0, getcmdpos()-1)<CR>

" Alt-Backspace deletes word backwards
cnoremap        <A-BS>          <C-W>
cnoremap        <Esc><BS>       <C-W>

" Do not lose "complete all"
cnoremap        <C-S-A>         <C-A>

" Windows style editing                                         {{{2
imap            <C-Del>         <C-O>dw
imap            <C-Backspace>   <C-O>db

map             <S-Insert>      "+p
imap            <S-Insert>      <C-O><S-Insert>
vmap            <C-Insert>      "+y

" ^Z = undo
" (works only in gvim, haven't used this in ages)
imap            <C-Z>           <C-O>u

" Function keys                                                 {{{2

" <F1> = help (default)
"-" Disable F1 -- it gets in the way of F2 on my ThinkPad
""map             <F1>            <Nop>
""imap            <F1>            <Nop>

" <F2> = save
map             <F2>            :update<CR>
imap            <F2>            <C-O><F2>

" <F3> = turn off search highlighting
map             <F3>            :nohlsearch<CR>
imap            <F3>            <C-O><F3>

" <S-F3> = turn off location list
map             <S-F3>            :lclose<CR>
imap            <S-F3>            <C-O><S-F3>

" <C-F3> = turn off quickfix
map             <C-F3>            :cclose<CR>
imap            <C-F3>            <C-O><C-F3>

" <F4> = next error/grep match
"" depends on plugin/quickloclist.vim
map             <F4>            :FirstOrNextInList<CR>
imap            <F4>            <C-O><F4>
" <S-F4> = previous error/grep match
map             <S-F4>          :PrevInList<CR>
imap            <S-F4>          <C-O><S-F4>
" <C-F4> = current error/grep match
map             <C-F4>          :CurInList<CR>
imap            <C-F4>          <C-O><C-F4>

""" <F5> = close location list (overriden by ImportName in .py files)
""map             <F5>            :lclose<CR>
""imap            <F5>            <C-O><F5>

" <F6> = cycle through buffers
map             <F6>            :bn<CR>
imap            <F6>            <C-O><F6>
" <S-F6> = cycle through buffers backwards
map             <S-F6>          :bN<CR>
imap            <S-F6>          <C-O><S-F6>
" <C-F6> = toggle .c/.h (see above) or code/test (see below)

" <F7> = jump to tag/filename+linenumber in the clipboard
map             <F7>            :ClipboardTest<CR>
imap            <F7>            <C-O><F7>

" <F8> = highlight identifier under cursor
" (some file-type dependent autocommands redefine it)
map             <F8>            :let @/='\<'.expand('<cword>').'\>'<bar>set hls<CR>
imap            <F8>            <C-O><F8>

" <F9> = make
map             <F9>    :make<CR>
imap            <F9>    <C-O><F9>

" <F10> = quit
" (some file-type dependent autocommands redefine it)
""map           <F10>           :q<CR>
""imap          <F10>           <ESC>

" <F11> = toggle 'paste'
set pastetoggle=<F11>

" <F12> = show the Unicode name of the character under cursor
map             <F12>           :UnicodeName<CR>
" <S-F12> = show highlight group under cursor
map             <S-F12>         :ShowHighlightGroup<CR>
" <C-F12> = show syntax stack under cursor
map             <C-F12>         :ShowSyntaxStack<CR>

"
" Autocommands                                                  {{{1
"

if has("autocmd")

" Kill visual bell! kill!                                       {{{2

augroup GUI
  au!
  au GUIEnter * set t_vb=
augroup END

" Remember last position in a file                              {{{2
" see :help last-position-jump
augroup LastPositionJump
  au!
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") && &ft != 'gitcommit' | exe "normal g'\"" | endif
augroup END

" Autodetect filetype on first save                             {{{2
augroup FiletypeOnSave
  au!
  au BufWritePost * if &ft == "" | filetype detect | endif
augroup END

" Reload SnipMate snippets on save                              {{{2
augroup ReloadSnippetsOnSave
  au!
  au BufWritePost ~/.vim/snippets/**/*.snippets call ReloadAllSnippets()
augroup END

" chmod +x on save                                              {{{2
augroup MakeExecutableOnSave
  " http://unix.stackexchange.com/questions/39982/vim-create-file-with-x-bit
  " See also http://vim.wikia.com/wiki/Setting_file_attributes_without_reloading_a_buffer
  au!
  au BufWritePost * if getline(1) =~ "^#!" && expand("%:t") !~ "test.*py" | silent exec '!chmod +x <afile>' | endif
augroup END

" Programming in Python                                         {{{2

function! FT_Python_Ivija()
  setlocal wildignore+=docs/src/** " make command-t ignore the duplicated subtree
  setlocal wildignore+=reportgen-output/**
  let g:pyTestRunnerClipboardExtras = '-vc'
endf

function! FT_Python_Schooltool()
  let g:pyTestRunnerClipboardExtras='-pvc1'
  let g:pyTestRunnerDirectoryFiltering = ''
  let g:pyTestRunnerModuleFiltering = ''
endf

function! FT_Python_Django()
  call UseDjangoTestRunner()
endf

function! FT_Python_Yplan()
  let g:pyTestRunnerClipboardExtras=''
  let g:pyTestRunnerDirectoryFiltering = ''
  let g:pyTestRunnerFilenameFiltering = " "
  let g:pyTestRunnerPackageFiltering = ""
  let g:pyTestRunnerModuleFiltering = ''
  let g:pyTestRunnerTestFiltering = ""
  let g:pyTestRunner = "../runlocaltests.sh"
  Margin 120
  setlocal makeprg=arc\ lint\ --output\ summary
endf

augroup Python_prog
  autocmd!
  autocmd BufRead,BufNewFile ~/src/ivija/**/*.txt  set ft=rst
  autocmd BufRead,BufNewFile *  if expand('%:p') =~ 'ivija' | call FT_Python_Ivija() | endif
  autocmd BufRead,BufNewFile *  if expand('%:p') =~ 'schooltool' | call FT_Python_Schooltool() | endif
  autocmd BufRead,BufNewFile *  if expand('%:p') =~ 'labtarna' | call FT_Python_Django() | endif
  autocmd BufRead,BufNewFile *  if expand('%:p') =~ 'masinis' | call FT_Python_Django() | endif
  autocmd BufRead,BufNewFile *  if expand('%:p') =~ 'yplan' | call FT_Python_Yplan() | endif
  autocmd BufRead,BufNewFile /var/lib/buildbot/masters/*/*.cfg  setlocal tags=/root/buildbot.tags
  autocmd BufRead,BufNewFile /usr/**/buildbot/**/*.py  setlocal tags=/root/buildbot.tags
augroup END

augroup JS_prog
  autocmd!
  autocmd FileType javascript   map <buffer> <C-F6>  :SwitchCodeAndTest<CR>
augroup END

function! FT_Mako()
  setf html
  setlocal includeexpr=substitute(v:fname,'^/','','')
  setlocal indentexpr=
  setlocal indentkeys-={,}
  map <buffer> <C-F6>  :SwitchCodeAndTest<CR>
endf

augroup Mako_templ
  autocmd!
  autocmd BufRead,BufNewFile *.mako     call FT_Mako()
augroup END

" Zope                                                          {{{2

function! FT_XML()
  setf xml
  if v:version >= 700
    setlocal shiftwidth=2 softtabstop=2 expandtab fdm=syntax
  elseif v:version >= 600
    setlocal shiftwidth=2 softtabstop=2 expandtab
    setlocal indentexpr=
  else
    set shiftwidth=2 softtabstop=2 expandtab
  endif
endf

function! FT_Maybe_ReST()
  if glob(expand("%:p:h") . "/*.py") != ""
        \ || glob(expand("%:p:h:h") . "/*.py") != ""
    " Why the FUCK does this FUCKING trigger when I'm editing a Mercurial
    " commit message, after I do :new
    if &ft == "text" || &ft == ""
        setlocal ft=rest
    endif
    setlocal shiftwidth=4 softtabstop=4 expandtab
    map <buffer> <F5>    :ImportName <C-R><C-W><CR>
    map <buffer> <C-F5>  :ImportNameHere <C-R><C-W><CR>
    map <buffer> <C-F6>  :SwitchCodeAndTest<CR>
  endif
endf

augroup Zope
  autocmd!
  autocmd BufRead,BufNewFile *.zcml                     call FT_XML()
  autocmd BufRead,BufNewFile *.xpdl                     call FT_XML()
  autocmd BufRead,BufNewFile *.pt                       call FT_XML()
  autocmd BufRead,BufNewFile *.tt                       setlocal et tw=44 wiw=44 fo=t
  autocmd BufRead,BufNewFile *.txt                      call FT_Maybe_ReST()
  autocmd BufRead,BufNewFile *.test                     call FT_Maybe_ReST()
augroup END

" /root/Changelog                                               {{{2

function! FT_RootsChangelog()
  setlocal expandtab
  setlocal formatoptions=crql
  setlocal comments=b:#,fb:-
  if v:version >= 704
    setlocal fo+=j " remove comment leader when joining lines
  endif
endf

augroup RootsChangelog
  autocmd!
  autocmd BufRead,BufNewFile /root/Changelog*   call FT_RootsChangelog()
augroup END

" blog posts                                                    {{{2

function! FT_MyBlog()
  setlocal sts=2 sw=2 spell ft=html
  map <buffer> <f5> :.!~/blog/blogify<cr>
  vmap <buffer> <f5> :!~/blog/blogify<cr>
  imap <buffer> <f5> <c-o><f5>
  map <buffer> <f9> :!~/blog/preview.sh<cr>
endf

augroup MyBlog
  autocmd!
  autocmd BufRead,BufNewFile ~/blog/data/*.txt  call FT_MyBlog()
  autocmd BufRead,BufNewFile ~/blog/blogify
              \ map <buffer> <F9> :wall\|setlocal makeprg=%\ --test\|make<CR>
augroup END

" BookServ dev                                                  {{{2

function! FT_BookServ_Py()
  let g:pyTestRunner = 'bin/test'
  let g:pyTestRunnerTestFiltering = "-m"
  let g:pyTestRunnerDirectoryFiltering = ""
  let g:pyTestRunnerPackageFiltering = ""
  let g:pyTestRunnerModuleFiltering = ""
  let g:pyTestRunnerClipboardExtras = ""
  let g:pyTestRunnerFilenameFiltering = " "
  setlocal path^=src/bookserv/templates,src/bookserv/public
  setlocal includeexpr=substitute(v:fname,'^/','','')
endf

augroup BookServ
  autocmd!
  autocmd BufRead,BufNewFile ~/src/bookserv/*.py        call FT_BookServ_Py()
augroup END

endif " has("autocmd")

"
" Colors                                                        {{{1
"

if $COLORTERM == "gnome-terminal"
  set t_Co=256                  " gnome-terminal supports 256 colors
  " note: doesn't work inside screen, which translates 256 colors into the
  " basic 16.
  " a better fix would be something like http://gist.github.com/636883
  " added to .bashrc
endif

if has("gui_running")
  gui                           " see :help 'background' why I need this before
  set t_vb=                     " this must be set after :gui
endif

" I want gvims to look the same as vims in my gnome-terminal (which uses Tango
" colours).  Unfortunately I need to keep switching these manually whenever I
" change the Gtk+ theme (between ones with white background and ones with dark
" background).
if !exists('colors_name')
  colorscheme whitetango
  "colorscheme darklooks
endif

if has("syntax")
  syntax enable
endif

" My colour overrides

highlight NonText               ctermfg=gray guifg=gray term=standout
highlight SpecialKey            ctermfg=gray guifg=gray term=standout
highlight MatchParen            gui=bold guibg=NONE guifg=lightblue cterm=bold ctermbg=255
highlight SpellBad              cterm=underline ctermfg=red ctermbg=NONE
highlight SpellCap              cterm=underline ctermfg=blue ctermbg=NONE

if $TERM == "Eterm"
  highlight StatusLine          ctermfg=white ctermbg=black cterm=bold
  highlight StatusLineNC        ctermfg=white ctermbg=black cterm=NONE
  highlight VertSplit           ctermfg=white ctermbg=black cterm=NONE
endif

" Get rid of italics (they look ugly)
highlight htmlItalic            gui=NONE guifg=orange
highlight htmlUnderlineItalic   gui=underline guifg=orange

" Make error messages more readable
highlight ErrorMsg              guifg=red guibg=white

" Python doctests -- I got used to one color, then upgraded the Python
" syntax script and it changed it
highlight link Test Special

" 'statusline' contains %1* and %2*
highlight User1                 gui=NONE guifg=green guibg=black
            \                   cterm=NONE ctermfg=green ctermbg=black
highlight User2                 gui=NONE guifg=magenta guibg=black
            \                   cterm=NONE ctermfg=magenta ctermbg=black

" for custom :match commands
highlight Red                   guibg=red ctermbg=red
highlight Green                 guibg=green ctermbg=green

" for less intrusive signs
highlight SignColumn guibg=#fefefe ctermbg=230

" gutter on the right of the text
highlight ColorColumn ctermbg=230

" gutter below the text
highlight NonText ctermbg=230
set shortmess+=I " suppress intro message because the above makes it look bad

" fold column aka gutter on the left
highlight FoldColumn ctermbg=230

" number column aka gutter on the left
highlight LineNr ctermbg=230
highlight CursorLineNr ctermbg=230 cterm=underline

" cursor column
highlight CursorColumn ctermbg=230
highlight CursorLine ctermbg=230

" avoid invisible color combination (red on red)
highlight DiffText ctermbg=1

" easier on the eyes
highlight Folded ctermbg=229

"
" Toolbar buttons                                               {{{1
"

if !exists("did_install_mg_menus") && has("gui")
  let did_install_mg_menus = 1
  amenu 1.200   ToolBar.-Sep700-        :
  amenu 1.201   ToolBar.TrimSpaces      :%s/\s\+$//<CR>
  tmenu         ToolBar.TrimSpaces      Remove trailing whitespace
  amenu 1.202   ToolBar.ToggleHdr       <C-F6>
  tmenu         ToolBar.ToggleHdr       Switch between source and header (C/C++), or code and test (Python)
endif

" vim:fdm=marker:
