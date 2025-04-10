" ~/.vim/vimrc by Marius Gedminas <marius@gedmin.as>
"
" I've tried to make it work with vim.tiny without errors, by sprinkling
" conditionals all over the place.
"

"
" Options                                                       {{{1
"
set nocompatible                " be modern (default if you have a .vimrc)

" Presentation                                                  {{{2
set laststatus=2                " always show a status line
set cmdheight=2                 " avoid 'Press ENTER to continue'
set guioptions-=L               " disable left scrollbar in GUI
set guioptions-=m               " disable GUI menu
set guicursor+=a:blinkon0       " disable cursor blinking
set shortmess-=S                " show N/M while searching
set showcmd                     " show partial commands in status line
set ruler                       " show cursor position in status line
set list                        " show tabs and spaces at end of line:
set listchars=tab:>-,trail:·,extends:>
if v:version >= 600
  set listchars+=precedes:<
endif
if v:version >= 700
  set listchars+=nbsp:_
endif
if has("linebreak")
  set linebreak                 " wrap lines at word boundaries, not mid-word
  let &sbr = nr2char(8618).' '  " show ↪ at the beginning of wrapped lines
endif
set display=lastline            " when last line doesn't fit, show most of it
if has("extra_search")
  set hlsearch                  " highlight search matches
  nohlsearch                    " but not initially
endif
if exists("&colorcolumn")
  let &colorcolumn=join(range(81,999),",") " highlight columns over 80
endif
set numberwidth=6               " I want it constant width everywhere
set title                       " set xterm title even in Wayland (where autodetect fails)

" I want gvim to look the same as vim in gnome-terminal
set guifont=Ubuntu\ Mono\ 13

" Silence                                                       {{{2
set noerrorbells                " don't beep!
set visualbell                  " don't beep!
set t_vb=                       " don't beep! (but also see t_vb= below)
if exists("&belloff")
  set belloff=all               " don't beep!
endif

" Interpreting file contents                                    {{{2
set modelines=5                 " debian disables this by default
set nomodeline                  " on second thought, debian has it right
set fileencodings=ucs-bom,utf-8,windows-1257 " autodetect

" Backup files                                                  {{{2
set backup                      " make backups
set backupdir=~/tmp             " but don't clutter $PWD with them

if $USER == "root"
  " 'sudo vi' on certain machines cannot write to ~/tmp (NFS root-squash)
  set backupdir=/root/tmp
endif

" create the backup directory if it doesn't already exist
function! s:Mkdir(dir)
  if !isdirectory(a:dir)
    if exists("*mkdir")
      call mkdir(a:dir, "p")
    else
      exec "silent !mkdir -p " . a:dir
    endif
  endif
endf
call s:Mkdir(&backupdir)

" Persistent undo (vim 7.3+)                                    {{{2
if has("persistent_undo")
  set undofile                  " enable persistent undo
  let &undodir=&backupdir . "/.vimundo" " but don't clutter $PWD
  call s:Mkdir(&undodir)
endif

" No swap files for unmodified buffers                          {{{2
set noswapfile
augroup Swap
  autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
      \ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif
augroup END

" Behaviour                                                     {{{2
set wildmenu                    " nice tab-completion on the command line
set wildmode=longest,full       " nicer tab-completion on the command line
set hidden                      " side effect: undo list is not lost on C-^
set browsedir=buffer            " :browse e starts in %:h, not in $PWD
set autoread                    " automatically reload files changed on disk
set history=1000                " remember more lines of cmdline history
set switchbuf=useopen           " quickfix reuses open windows
set iskeyword-=/                " Ctrl-W in command-line stops at /
set splitright                  " put new splits on the right please
set nrformats-=octal            " Ctrl-A/X on YYYY-0M-0D
if has('patch-8.2.0860')
  set nrformats+=unsigned       " Ctrl-A/X on YYYY-MM-DD
endif

if has('mouse_xterm')
  set mouse=a                   " use mouse in xterms
endif

set clipboard&
set clipboard-=autoselect       " unnamed + autoselect = can't use Vp to replace
set clipboard^=unnamed          " interoperate with the X clipboard

if v:version >= 700
  set diffopt+=vertical         " split diffs vertically
  set spelllang=en,lt           " spell-check two languages at once
endif

if exists('&splitkeep')
  set splitkeep=screen          " avoid scrolling text when creating splits
endif
if exists('&smoothscroll')
  set smoothscroll              " allow scrolling by screen line (^Y/^E only for now)
endif

" Input                                                         {{{2

set ttimeout ttimeoutlen=20     " timeout keys after 20ms (mappings time out after 1 s)
                                " doesn't seem to work for <esc>Ok
set updatetime=250              " faster CursorHold events for vim-gitgutter

" Movement                                                      {{{2
set incsearch                   " incremental searching
set scrolloff=2                 " always keep cursor 2 lines from screen edge
set nostartofline               " don't jump to start of line

" Folding                                                       {{{2
if &foldmethod == 'manual'
" set foldmethod=marker         " use folding by markers by default
  set foldmethod=syntax         " use syntax folding by default
endif
set foldlevelstart=9999         " initially open all folds

" Editing                                                       {{{2
set nowrap                      " do not wrap long lines
set backspace=indent,eol,start  " sensible backspacing
set shiftwidth=4                " more-or-less reasonable indents
set softtabstop=-1              " make the <tab> key more useful
set tabstop=8                   " anything else is heresy
set expandtab                   " tabs are evil
set noshiftround                " do NOT enforce the indent
set autoindent                  " automatic indent
set nosmartindent               " but no smart indent (ain't smart enough)
set copyindent                  " no tabs if previous line used spaces
set preserveindent              " no tabs if line didn't use them before
set isfname-=\=                 " fix filename completion in VAR=/path
if v:version >= 704
  set fo+=j                     " remove comment leader when joining lines
  let &flp='^\s*\d\+[\]:.)}\t ]\s*'  " default value
  let &flp.='\|^\s*[-*]\s'           " also recognize bulleted lists
endif

" Editing code                                                  {{{2
set path&
set path+=/usr/include/i386-linux-gnu   " multiarch on ubuntu
set path+=/usr/include/x86_64-linux-gnu " multiarch on ubuntu
set path+=**                    " let :find do recursive searches
set tags&
set tags-=./TAGS                " ignore emacs tags to prevent duplicates
set tags-=TAGS                  " ignore emacs tags to prevent duplicates
set tags-=./tags                " bin/tags is not a tags file
set tags+=tags;$HOME            " look for tags in parent dirs
set suffixes&
set suffixes+=.class            " ignore Java class files
set suffixes+=.pyc,.pyo         " ignore compiled Python files
set suffixes+=.egg-info         " ignore compiled Python files
set suffixes+=.~1~,.~2~         " ignore Bazaar droppings
set suffixes+=.png              " don't edit .png files please
set wildignore&
set wildignore+=*.pyc,*.pyo     " same as 'suffixes', but for tab completion
set wildignore+=*.[oad],*.so    " and, more importantly, Command-T
set wildignore+=*/__pycache__/* " compiled python files
set wildignore+=*.egg-info/     " setuptools droppings
set wildignore+=*/*.egg-info/*  " setuptools droppings
set wildignore+=*~              " backup files
" most of these directory ignores are probably broken because they don't have
" the trailing /* which appears to be necessary, in addition to the leading */
set wildignore+=*/build         " distutils, I hates them
set wildignore+=*/dist          " distutils deliverables
set wildignore+=*/htmlcov       " coverage.py html reports
set wildignore+=*/coverage      " zope.testrunner --coverage
set wildignore+=*/parts         " all buildout-generated junk even
set wildignore+=*/.venv         " virtualenv
set wildignore+=*/python        " virtualenv called 'python'
set wildignore+=*/eggs          " buildout?
set wildignore+=*/.eggs         " setuptools
"set wildignore+=.tox/*         " tox -- I find it useful to :e files from .tox/
set wildignore+=*/_build        " sphinx
set wildignore+=*/node_modules  " thousands of files, omg
set wildignore+=*/obj-x86_64-pc-linux-gnu/*  " firefox builds, 43018 files
set wildignore+=.ruff_cache     " ruff, a Python linter

if v:version >= 700
  set complete-=i               " don't autocomplete from included files (slow)
  set completeopt-=preview      " don't show the preview window
endif

" Pytest syntax errors                                          {{{2

" Reset error format so that sourcing .vimrc again and again doesn't grow it
" without bounds
set errorformat&

" For the record, the default errorformat is this:
"
"   %*[^"]"%f"%*\D%l: %m
"   "%f"%*\D%l: %m
"   %-G%f:%l: (Each undeclared identifier is reported only once
"   %-G%f:%l: for each function it appears in.)
"   %-GIn file included from %f:%l:%c:
"   %-GIn file included from %f:%l:%c\,
"   %-GIn file included from %f:%l:%c
"   %-GIn file included from %f:%l
"   %-G%*[ ]from %f:%l:%c
"   %-G%*[ ]from %f:%l:
"   %-G%*[ ]from %f:%l\,
"   %-G%*[ ]from %f:%l
"   %f:%l:%c:%m
"   %f(%l):%m
"   %f:%l:%m
"   "%f"\, line %l%*\D%c%*[^ ] %m
"   %D%*\a[%*\d]: Entering directory %*[`']%f'
"   %X%*\a[%*\d]: Leaving directory %*[`']%f'
"   %D%*\a: Entering directory %*[`']%f'
"   %X%*\a: Leaving directory %*[`']%f'
"   %DMaking %*\a in %f
"   %f|%l| %m
"
" and sometimes it misfires, so let's fix it up a bit
" (TBH I don't even know what compiler produces filename(lineno) so why even
" have it?)
set errorformat-=%f(%l):%m

" Sometimes Vim gets confused about ISO-8601 timestamps and thinks they're
" filenames; this is a big hammer that ignores anything filename-like on lines
" that start with at least two spaces, possibly preceded by a number and
" optional punctuation
set errorformat^=%+G%\\d%#%.%\\=\ \ %.%#

" Similar, but when the entire line starts with a date
set errorformat^=%+G\\d\\d\\d\\d-\\d\\d-\\d\\d\ \\d\\d:\\d\\d%.%#

" make: *** [Makefile:14: target] Error 1
set errorformat^=%+Gmake:\ ***\ %.%#

" FAILED tests.py::test_with_params[YYYY-MM-DD:HH:MM:SS] - Exception: bla bla
set errorformat^=%+GFAILED\ %.%#

" AssertionError: assert ...YYYY-MM-DD:HH:MM:SS...
set errorformat^=%+GAssertionError:\ %.%#

" --- /path/to/file:before  YYYY-MM-DD HH:MM:SS.ssssss
set errorformat^=---%f:%m

" +++ /path/to/file:before  YYYY-MM-DD HH:MM:SS.ssssss
set errorformat^=+++%f:%m

" Sometimes pytest prepends an 'E' marker at the beginning of a traceback line
set errorformat+=E\ %#File\ \"%f\"\\,\ line\ %l%.%#

" Python tracebacks (unittest + doctest output)                 {{{2

" This collapses the entire traceback into just the last file+lineno,
" which is convenient when you want to jump to the line that failed (and not
" the top-level entry point), but it makes it impossible to see the full
" traceback, which sucks.
""set errorformat+=
""            \File\ \"%f\"\\,\ line\ %l%.%#,
""            \%C\ %.%#,
""            \%-A\ \ File\ \"unittest%.py\"\\,\ line\ %.%#,
""            \%-A\ \ File\ \"%f\"\\,\ line\ 0%.%#,
""            \%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,
""            \%Z%[%^\ ]%\\@=%m

set errorformat+=
      \File\ \"%f\"\\,\ line\ %l\\,%#%m

" Shell scripts                                                 {{{2
if has("eval")
  let g:is_posix = 1            " /bin/sh is POSIX, not ancient Bourne shell
  let g:sh_fold_enabled = 7     " fold functions, heredocs, ifs/loops
endif

" C headers                                                     {{{2
if has("eval")
  let g:c_syntax_for_h = 1      " assume *.h are C, not C++
endif

" Markdown                                                      {{{2
let g:markdown_fenced_languages=['ini', 'console', 'python']

" Netrw explorer                                                {{{2
if has("eval")
  let g:netrw_list_hide = '.*\.swp\($\|\t\),.*\.py[co]\($\|\t\),__pycache__'
  let g:netrw_sort_sequence = '[\/]$,*,\.bak$,\.o$,\.h$,\.info$,\.swp$,\.obj$,\.py[co]$'
  let g:netrw_timefmt = '%Y-%m-%d %H:%M:%S'
endif

"
" Abbreviations                                                 {{{1
"

" I keep mistyping these
abbrev Pyhton Python
abbrev PYthon Python
abbrev improt import
abbrev retunr return
abbrev PAth Path
abbrev ehco echo
abbrev wiht with
abbrev reosurce resource
abbrev MAke Make
abbrev assing assign

"
" Plugins                                                       {{{1
"

" Builtin plugins                                               {{{2

" :Cfilter /pat/ to filter quickfix list
packadd! cfilter

" vim-plug plus list of plugins to install                      {{{2

if has("eval")
  call plug#begin('~/.vim/bundle')

  " :help for vim-plug itself                                   {{{3

  Plug 'junegunn/vim-plug'

  " Programming                                                 {{{3

  " Show syntax errors and style warning in files I edit.  Updates
  " asynchonously (requires Vim 8).
  if has('nvim') || has('timers') && exists('*job_start') && exists('*ch_close_in')
    let g:ale_set_balloons = 1   " must be set before loading ale
    Plug 'w0rp/ale'
    let g:ale_linters = {}
    let g:ale_linters.python = ['flake8']
    let g:ale_linters.rust = ['cargo']
    let g:ale_fixers = {}
    let g:ale_fixers.javascript = ['prettier']
    let g:ale_fixers.typescript = ['prettier']
    let g:ale_fixers.python = ['isort']
    let g:ale_fixers.rust = ['rustfmt']
    let g:ale_fixers.yaml = ['prettier']
    if filereadable(expand('~/.cargo/bin/rust-analyzer'))
      let g:ale_linters.rust = ['analyzer', 'cargo']
    endif
    " see https://github.com/w0rp/ale/issues/1827#issuecomment-433920827
    let g:ale_python_flake8_change_directory = 0
    let g:ale_rust_cargo_use_clippy = 1
  else
    " Show syntax errors and style warnings in files I edit.  Updates on save.
    Plug 'scrooloose/syntastic'
  endif

  " Update tags file automagically
  Plug 'ludovicchabant/vim-gutentags'
  " As suggested in https://github.com/ludovicchabant/vim-gutentags/issues/113,
  " to only update existing tags files and never create new ones:
  let g:gutentags_project_root = ['tags']
  let g:gutentags_add_default_project_roots = 0
  let g:gutentags_generate_on_missing = 0
  let g:gutentags_generate_on_new = 0

  " Base64 encode/decode on <leader>atob and <leader>btoa in visual mode
  Plug 'christianrondeau/vim-base64'
  " and since I can never remember the mappings
  vmap <leader>a2b <leader>atob
  vmap <leader>b2a <leader>btoa

  " Show [current_function] in the status line for supported file types (C, Python, JS, diff)
  Plug 'mgedmin/taghelper.vim'

  " Comment out stuff with gc<motion> (gcc for the current line)
  Plug 'tpope/vim-commentary'

  " Programming: VimScript                                      {{{3

  Plug 'junegunn/vader.vim'


  " Programming: Rust                                           {{{3

  Plug 'rust-lang/rust.vim'


  " Programming: JavaScript                                     {{{3

  Plug 'yuezk/vim-js'
  Plug 'MaxMEllon/vim-jsx-pretty'


  " Programming: Python                                         {{{3

  " Random Python code refactorings like :SortList, :SwapAssignment etc.
  Plug 'mgedmin/python-refactorings.vim'

  " Insert Python import statements computed from tags, bound to <F5>
  Plug 'mgedmin/python-imports.vim', {'on': ['ImportName', 'ImportNameHere']}

  " A smarter :Tag [package.][module.][class.]name command for Python
  " (my ftplugin/python.vim also remaps Ctrl-] to use it)
  Plug 'mgedmin/pytag.vim', {'on': ['Tag'], 'for': 'python'}

  " <Leader>oo to jump to Python standard library source code
  " (my fork because bugfixes)
  Plug 'mgedmin/python_open_module.vim'

  " Python folding, to replace my hacky syntax/python.vim perhaps?
  " (I'm not ready to switch yet)
""Plug 'tmhedberg/SimpylFold'

  " Automate switching between code and unit test files, bound to <C-F6>
  Plug 'mgedmin/test-switcher.vim', {'on': ['SwitchCodeAndTest', 'TestForTheOtherWindow', 'OpenTestInOtherWindow']}

  " Run test under cursor
  Plug 'mgedmin/py-test-runner.vim'

  " Locate the source code line from clipboard contents, bound to <F7>
  Plug 'mgedmin/source-locator.vim', {'on': ['ClipboardTest', 'LocateTest']}

  " :EnableTestOnSave and have fun doing code katas
  Plug 'mgedmin/test-on-save.vim', {'on': ['EnableTestOnSave', 'RunTests']}

  " :HighlightCoverage for Python
  Plug 'mgedmin/coverage-highlight.vim', {'on': ['HighlightCoverage', 'HighlightCoverageForAll', 'HighlightCoverageOff', 'ToggleCoverage', 'PrevUncovered', 'NextUncovered']}
  let g:coverage_script = 'coverage'
  noremap [C :<C-U>PrevUncovered<CR>
  noremap ]C :<C-U>NextUncovered<CR>
  noremap <M-Up> :<C-U>PrevUncovered<CR>
  noremap <M-Down> :<C-U>NextUncovered<CR>

  " Better Python autoindentation
  Plug 'Vimjas/vim-python-pep8-indent'
  " Misbehaves for long literals (over 50 lines), see
  " https://github.com/Vimjas/vim-python-pep8-indent/pull/90

  " More up-to-date Python syntax that supports f-strings and everything
  " Well.  It used to be up-to-date.  Last commit 4 years ago, doesn't support
  " match statements.
  ""Plug 'vim-python/python-syntax'
  ""let python_slow_sync = 1
  let python_highlight_all = 1  " builtin python syntax also supports this

  " :Pydoc
  Plug 'fs111/pydoc.vim'
  let g:pydoc_cmd = 'python3 -m pydoc'

  " :BlackMachiatto to autoformat the selected range of lines; needs pipx
  " install black-machiatto
  Plug 'smbl64/vim-black-macchiato'
  let g:black_macchiato_args = "-S -l79"

  " Version control integration                                 {{{3

  " Git integration -- :Gdiff, :Ggrep etc.
  Plug 'tpope/vim-fugitive'
  let g:fugitive_legacy_commands = 1  " :Gbrowse, :Gblame are burned into my muscle memory

  " GitHub support for vim-fugitive
  Plug 'tpope/vim-rhubarb'

  " Gitlab support for vim-fugitive
  Plug 'shumphrey/fugitive-gitlab.vim'
  let g:fugitive_gitlab_domains = {
        \ 'https://gitlab.gnome.org': 'https://gitlab.gnome.org',
        \ 'ssh://gitlab.tilaajavastuu.fi:2222': 'https://git.vaultit.org/',
        \ }

  " Azure DevOps support for vim-fugitive
  Plug 'cedarbaum/fugitive-azure-devops.vim'

  " Git log browsing (unmaintained)
  Plug 'gregsexton/gitv', {'on': ['Gitv']}

  " Git log browsing (alternative)
  Plug 'rbong/vim-flog', {'on': ['Flog', 'Flogsplit']}

  " Show git change status for each line in the gutter
  Plug 'airblade/vim-gitgutter'

  " Higlight git conflict markers in files
  Plug 'vim-scripts/ingo-library'
  Plug 'vim-scripts/ConflictDetection'

  " Use [x/]x to navigate to conflict markers
  Plug 'vim-scripts/CountJump'
  Plug 'vim-scripts/ConflictMotions'

  " Version control integration for SVN and other legacy VCSes -- :VCSVimDiff
  Plug 'vim-scripts/vcscommand.vim'

  " Load previous svn-commit.tmp automatically when you repeat 'svn ci' after
  " a failed commit.
  Plug 'vim-scripts/svn_commit'

  " Show the svn diff while I'm editing an svn commit message.
  Plug 'vim-scripts/svn-diff.vim'


  " Navigation                                                  {{{3

  " Open files by typing a subsequence of the pathname, bound to <Leader>t
  if has('ruby')
    Plug 'wincent/command-t', {
      \ 'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make' }
    let g:CommandTPreferredImplementation = 'ruby'
  endif

  " Pure-python alternative to command-t, slightly different UI, not as nice
  " to use as command-t but useful for some circumstances (Vim w/o Ruby).
  " Bound to <C-P>
  Plug 'vim-scripts/ctrlp.vim'

  " List open buffers with various sorting modes on \be
  Plug 'jlanzarotta/bufexplorer'

  " File tree in a sidebar.  Bound to <Leader>N, <Leader>f
  Plug 'preservim/nerdtree', {
        \ 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind'] }
  Plug 'Xuyuanp/nerdtree-git-plugin'
  let g:NERDTreeGitStatusIndicatorMapCustom = {
        \ 'Modified'  :'*',
        \ 'Staged'    :'+',
        \ 'Untracked' :'?',
        \ 'Renamed'   :'>',
        \ 'Unmerged'  :'=',
        \ 'Deleted'   :'x',
        \ 'Dirty'     :'*',
        \ 'Ignored'   :'I',
        \ 'Clean'     :'v',
        \ 'Unknown'   :'?',
        \ }


  " Extending vim's features                                    {{{3

  " Show ASCII-art representation of Vim's undo tree, with bonus unified diffs
  Plug 'sjl/gundo.vim'
  let g:gundo_prefer_python3 = has('python3')  " Unbreak broken default config

  " :MacroEdit q
  Plug 'dohsimpson/vim-macroeditor'

  " Defines the very useful :Rename newfilename.txt
  Plug 'vim-scripts/Rename'

  " :%S/foo/bar/gc --> case-preserving :%s
  Plug 'tpope/vim-abolish'

  " Replace 'ga' to show Unicode names etc.
  Plug 'tpope/vim-characterize'

  " ^P/^N completion on the command line
  Plug 'vim-scripts/CmdlineComplete'

  " Emacs-like Alt-t transpose words
  Plug 'vim-scripts/transpose-words'
  if !has('nvim')
    exec "set <M-t>=\<Esc>t"
  endif

  " Snippets!  Type some text, press <tab> to expand, with get expansion with
  " multiple placeholders you can keep or replace and tab over.
  " Supposedly better than SnipMate which I used earlier.
  if has('python') || has('python3')
    Plug 'SirVer/UltiSnips'
  endif

  " Default snippet collection -- I don't use them!
  ""Plug 'honza/vim-snippets'

  " Enable vim filename:lineno and :e filename:lineno
  Plug 'kopischke/vim-fetch'

  " Edit symlink targets instead of symlinks
  " (mostly because I want fugitive to work on my dotfiles repo)
  Plug 'aymericbeaumet/symlink.vim'

  " symlink.vim: 'moll/vim-bbye' is required in order for this plugin to
  " properly work in diff mode
  Plug 'moll/vim-bbye'

  " Async shell commands (see :Make)
  Plug 'skywind3000/asyncrun.vim'

  " :EasyAlign
  Plug 'junegunn/vim-easy-align'

  " :Tabularize
  Plug 'godlygeek/tabular'

  " Resize quickfix windows to fit content -- broooken currently
  " see https://github.com/blueyed/vim-qf_resize/issues/5
  "Plug 'blueyed/vim-qf_resize'

  " Text objects for vim's folds (vaz etc.)
  Plug 'kana/vim-textobj-user'
  Plug 'kana/vim-textobj-fold'

  " The popular vim-surround that I hate every time I try
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'

  " Show vim command output in a buffer, e.g. :Bufferize scriptnames
  Plug 'AndrewRadev/bufferize.vim'
  let g:bufferize_keep_buffers = 1

  " Tell me which vim version introduced a feature with :HelpfulVersion foo
  Plug 'tweekmonster/helpful.vim'

  " Sum numbers in visual selection
  Plug 'emugel/vim-sum'
  vmap <Esc>= <Plug>VimSumVisual

  " :StartupTime
  Plug 'dstein64/vim-startuptime'

  " Highlight whatever was yanked, briefly
  Plug 'machakann/vim-highlightedyank'
  let g:highlightedyank_highlight_duration = 250
  let g:highlightedyank_highlight_in_visual = 0

  " Highlight whatever was pasted, briefly (too briefly)
  Plug 'MaxMEllon/vim-shiny'
  nmap p  <Plug>(shiny-p)
  nmap P  <Plug>(shiny-P)
  nmap gp <Plug>(shiny-gp)
  nmap gP <Plug>(shiny-gP)

  " Additional filetypes                                        {{{3

  " LESS (the CSS preprocessor) syntax
  Plug 'groenewege/vim-less'

  " Vala syntax
  Plug 'tkztmk/vim-vala'

  " Improved ReStructuredText syntax
  Plug 'mrsipan/vim-rst'

  " Folding for Markdown files
  Plug 'masukomi/vim-markdown-folding'

  " Improved YAML syntax for Ansible
  Plug 'chase/vim-ansible-yaml'

  " YAML folding
  Plug 'pedrohdz/vim-yaml-folds'

  " Jinja syntax
  " (my fork because mitsuhiko is MIA and ignores GH issues)
  Plug 'mgedmin/vim-jinja'

  " Nginx syntax
  Plug 'vim-scripts/nginx.vim'
  " huh this has no ftdetect plugin??  and stock vim doesn't either?

  " xchat log syntax highlighting (set ft=xchatlog)
  Plug 'vim-scripts/xchat-log-syntax'
  " there's also 'XChat-IRC-Log' (set ft=irclog), but it fails to highlight
  " anything?

  " Syntax for Robot Framework tests
  Plug 'mfukar/robotframework-vim'

  " Jenkinsfile
  Plug 'martinda/Jenkinsfile-vim-syntax'

  " PostgreSQL
  Plug 'lifepillar/pgsql.vim'
  let g:sql_type_default = 'pgsql'


  "                                                             }}}3

  call plug#end()
endif

" Filetype plugins                                              {{{2
if v:version >= 600
  filetype plugin on            " load filetype plugins
  filetype indent on            " load indent plugins
endif

" Syntastic (which I no longer use if ALE is available)         {{{2

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

  " don't check json files; I rarely edit these and sometimes they're huge
  " which makes jshint slow
  " the same applies to configure scripts
  let g:syntastic_ignore_files = ['\.json$', '^configure$']
endif

" A.L.E.

if has("eval")
  let g:ale_sign_error = '>>'
  let g:ale_sign_warning = '>>'
  if exists('*sign_getdefined') && sign_getdefined('ALEErrorSign') != []
    " If you want to change the sign text after they've been defined (e.g.
    " if you edit the .vimrc and source it), you have to re-define the sign.
    runtime! autoload/ale/sign.vim
  endif

  let g:ale_statusline_format = ['{%d}', '{%d}', '']

  " if I become annoyed about ALE showing errors for half-typed text, perhaps
  " I'll want to uncomment these:
  ""let g:ale_lint_on_save = 1
  ""let g:ale_lint_delay = 1000
  ""let g:ale_lint_on_text_changed = 0

  nmap <Leader>af <Plug>(ale_fix)
endif

" Command-t                                                     {{{2

if has("eval")
  let g:CommandTCursorEndMap = ['<C-e>', '<End>']       " add End
  let g:CommandTCursorStartMap = ['<C-a>', '<Home>']    " add Home
  let g:CommandTCursorLeftMap = ['<Left>']              " remove ^H
  let g:CommandTCursorRightMap = ['<Right>']            " remove ^L
  let g:CommandTClearPrevWordMap = ['<C-w>', '<C-h>']   " add ^H aka Ctrl-BS
  let g:CommandTCancelMap = ['<C-c>', '<Esc>', '<C-g>'] " add ^G
  let g:CommandTMaxHeight = 20
  let g:CommandTTraverseSCM = "pwd"
  ""let g:CommandTFileScanner = "find"  " should be faster than the default 'ruby'
  " I may want to experiment with these:
  let g:CommandTFileScanner = "git"
  let g:CommandTGitIncludeUntracked = 1

  if exists(":CommandTFlush")
    " In case we changed &wildignore and want to test it
    CommandTFlush
  endif

  " Allow Command-T to replace bufexplorer windows
  let g:CommandTWindowFilter = '!&buflisted && &buftype == "nofile" && &filetype != "bufexplorer"'

  "let g:CommandTMaxFiles=800000  " firefox source tree is _big_
  " OTOH my home directory is also big and it sucks that I cannot interrupt
  " command-t with a ctrl-c when I accidentally trigger it there

  let g:CommandTMaxFiles=10000  " it's unbearably slow after 10000 files

  nmap <silent> <Leader>T <Plug>(CommandTTag)
  nmap <silent> <Leader>B <Plug>(CommandTBuffer)
  nmap <silent> <Leader>H <Plug>(CommandTHelp)
endif

" ctrlp.vim                                                     {{{2

if has("eval")
  let g:ctrlp_match_window_reversed = 1
  let g:ctrlp_reuse_window = 'netrw\|BufExplorer'
  let g:ctrlp_custom_ignore = {
              \ 'dir': '\v[\/]build$',
              \ }
  " make ctrl-f refresh the file cache like command-t
  " nb: changes the default meaning of ctrl-f which is "switch to next mode",
  " but I don't use modes
  let g:ctrlp_prompt_mappings = {
              \ 'PrtClearCache()':      ['<F5>', '<c-f>'],
              \ }
  " faster scanning maybe
  let g:ctrlp_user_command =
        \ ['.git', 'cd %s && git ls-files . -co --exclude-standard']
endif

" bufexplorer.vim                                               {{{2

if has("eval")
  let g:bufExplorerShowRelativePath = 1
  let g:bufExplorerSplitOutPathName = 0
  let g:bufExplorerShowNoName = 1
endif

" YouCompleteMe (which I no longer use)                         {{{2

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

" vim-scripts/git-commit (which I no longer use)                {{{2
if has("eval")
  let git_diff_spawn_mode = 1   " auto-split by default
endif

" bzr syntax plugin                                             {{{2
if has("eval")
  " NB: it uses an exists() check, so don't set it to 0 if you want it off
  let bzr_highlight_diff = 1
endif

" NERD_tree.vim                                                 {{{2
if v:version >= 700 && has("eval")
  let g:NERDTreeIgnore = [
        \ '\.py[co]$', '\~$', '^tags$', '^__pycache__$', '\.sw[a-z]$',
        \ '^\.cache$', '^\.git$', '^\.tox$', '\.egg-info$',
        \ '^\.mypy_cache$', '^\.pytest_cache$', '^\.eggs$', '^\.ruff_cache$',
        \ ]
  let g:NERDTreeHijackNetrw = 0
  let g:NERDTreeShowHidden = 1
  " let g:NERDRespectWildIgnore = 1 <-- hmm, why didn't I have this one
  " instead of overriding g:NERDTreeToggle?  Either it's new, or it ignores
  " something that I ordinarily want to see, like node-modules.
endif

map <Leader>n :NERDTreeToggle<CR>
map <Leader>N :NERDTreeFocus<CR>
map <expr> <Leader>f
      \ expand("%") == "" ? ":NERDTreeFocus\<CR>" :
      \ filereadable(expand("%")) ? ":NERDTreeFind\<CR>" : ":NERDTreeFind %:h\<CR>O"

" jedi.vim (which I no longer use)                              {{{2
if has("eval")
  " show_function_definition is a hack that modified your source buffer
  " and interacts badly with syntax highlighting
  let g:jedi#show_function_definition = "0"
  " I type 'import zope.component', I see 'import zope.interfacecomponent'
  " because jedi autocompletes the only zope subpackage it finds in
  " site-packages, unmindful about my virtualenvs/buildouts.
  let g:jedi#popup_select_first = 0
endif

" netrw.vim open plugin repo with gx in .vimrc                  {{{2
fun! Netrw_get_URL_vim()
  let plugin_url = ''
  try
    let save_view = winsaveview()
    if getline('.') =~ "^\\s*Plug\\s\\+'.*'"
      let plugin_url = matchstr(getline('.'), "^\\s*Plug\\s\\+'\\zs.*\\ze'")
      if plugin_url !~ '://'
        let plugin_url = 'https://github.com/' .. plugin_url
      endif
      return plugin_url
    endif
  finally
    call winrestview(save_view)
    return plugin_url
  endtry
endf

" asyncrun.vim + fugitive.vim = <3                              {{{2
if has("user_commands")
  " :Make as described in
  " https://github.com/skywind3000/asyncrun.vim/wiki/Cooperate-with-famous-plugins
  " now :Gpush and :Gfetch are async!
  command! -bang -bar -nargs=* Gpush execute 'AsyncRun<bang> -cwd=' .
              \ fnameescape(FugitiveGitDir()) 'git push' <q-args>
  command! -bang -bar -nargs=* Gfetch execute 'AsyncRun<bang> -cwd=' .
              \ fnameescape(FugitiveGitDir()) 'git fetch' <q-args>
  command! -bang -nargs=* -complete=file Make
              \ silent wall
              \ | AsyncRun -program=make @ <args>
  command! -bang -nargs=* -complete=file VerboseMake
              \ silent wall
              \ | echo &makeprg <q-args>
              \ | AsyncRun -program=make @ <args>
  command! -bang -nargs=* Tox
              \ silent wall
              \ | AsyncRun tox <args>
endif
if has("eval")
  fun! ResetStatusLineColor()
    if g:asyncrun_status != 'running'
      hi! link StatusLine StatusLineNeutral
      call mg#statusline_highlight()
    endif
  endf
  " hmm should I use autocmd User AsyncRunStop ... ?
  " anyway you can add on top of this with
  "  autocmd User AsyncRunStop HighlightCoverageForAll
  fun! OnAsyncRunExit()
    if exists(":GitGutter")
      " No real reason to do this here, but why not?  I often switch
      " to another terminal, git commit, switch back then idly run 'make
      " coverage'
      GitGutter
    endif
    if g:asyncrun_status == 'success'
      hi! link StatusLine StatusLineSuccess
      cclose
      call mg#statusline_highlight()
      call mg#statusline_update()
    elseif g:asyncrun_status == 'failure' && g:asyncrun_code != -1
      hi! link StatusLine StatusLineFailure
      if mode() == "n"
        botright cw
      else
        let curwin = winnr()
        botright cw
        exec curwin . "wincmd w"
      endif
      " update folds
      normal zx
      call mg#statusline_highlight()
    else
      hi! link StatusLine StatusLineNeutral
      call mg#statusline_highlight()
      call mg#statusline_update()
    endif
    redrawstatus!
    " perhaps echo 'async job finished:' g:asyncrun_code
    " but I tried that and didn't like it
    call FocusOnTestFailure()
    if g:asyncrun_info == "-program=make @ " && (&makeprg == "make coverage" || &makeprg == "tox -e coverage")
      HighlightCoverageForAll
    elseif g:asyncrun_info == "tox -e coverage" || g:asyncrun_info == "-program=make @ coverage"
      HighlightCoverageForAll
    elseif g:asyncrun_status == 'success'
      echo "Success!"
    endif
  endf
  let g:asyncrun_exit = "call OnAsyncRunExit()"
endif
if has("autocmd")
  augroup AsyncRun
    au!
    au User AsyncRunStart hi! link StatusLine StatusLineRunning | call mg#statusline_highlight() | redrawstatus!
  augroup END
endif

"
" Status line                                                   {{{1
"

" To emulate the standard status line with 'ruler' set, use this:
"
"   set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"
" I've tweaked it a bit to show the buffer number on the left, and the total
" number of lines on the right.  Also, show the current C or Python function
" in the status line, if the chelper/pythonhelper.vim plugins have been
" loaded.  Also, show if there are any Syntastic/ALE errors, and whether
" some evil plugin has once again used :lcd without my consent.
"
" And then I went ahead and overengineered everything in autoload/mg.vim
" And then later copied the aesthetics of lightline.vim.

" I forgot why I hated :lcd.  Now I hate how netrw uses :lcd and puts the icon
" in my statusline, so let's disable that and see if I hate :lcd when I cannot
" see it.
let g:show_lcd_in_status = 0

call mg#statusline_enable()
call mg#tabline_enable()

if has("autocmd")
  " Make sure to update the lint error counter in the statusline whenever the
  " linter finishes running in the background
  augroup ALEProgress
    autocmd!
    autocmd User ALELintPost call mg#statusline_update()
  augroup END
endif

"
" Commands                                                      {{{1
"

if has("user_commands")

" like :Explore, only never split windows                       {{{2
" workaround for https://github.com/vim/vim/issues/1506
command! -nargs=* -complete=file E exec "e" (<q-args> != "" ? <q-args> : mg#curdir#get())

" how many occurrences of the current search pattern?           {{{2
command! -range=% CountMatches          <line1>,<line2>s///n

" die, trailing whitespace! die!                                {{{2
command! -range=% NukeTrailingWhitespace <line1>,<line2>s/\s\+$//

" where's that non-ascii character?                             {{{2
command! FindNonAscii                   normal /[^\x00-\x7f]<cr>
command! FindControlChars               normal /[\x00-\x08\x0a-\x1f\x7f]<cr>

" where's the next untranslated message in a .po file?          {{{2
command! FindUntranslated               normal /msgstr\(\[\d\+\]\)\= ""\ze\n\n/e<cr>
command! FindUntranslatedOrFuzzy        normal /msgstr\(\[\d\+\]\)\= ""\ze\n\n\|^#.*, \zsfuzzy\>/e<cr>

" what are .po file stats?                                      {{{2
command! -bar PoStats
            \ echo system("msgfmt --statistics -c -o /dev/null -", bufnr("%"))

" convert \uXXXX to actual characters                           {{{2
command! -range=% ExpandUnicode         <line1>,<line2>s/\\u\([0-9a-fA-F]\{4}\)/\=nr2char(str2nr(submatch(1), 16))/gc

" diffoff used to set wrap as a side effect                     {{{2
command! Diffoff                        diffoff | setlocal nowrap

" See :help DiffOrig                                            {{{2
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                  \ | wincmd p | diffthis

" ShowMerge find the merge commit while looking at a commit in fugitive
command! ShowMerge call mg#fugitive#ShowMerge()

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

" :CW is a better :cw                                           {{{2
" (but maybe I should add 'wincmd J' to ftplugin/qf.vim instead?)
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
    let &colorcolumn=join(range(a:1+1,a:1+256),",")
  else
    echo min(split(&colorcolumn, ',')) - 1
  endif
endf
command! -nargs=? -bar Margin  call s:Margin(<args>)
command! -bar MarginOff        set colorcolumn=

" :NoLCD -- stop having a local working directory per window    {{{2
command! NoLCD          exe 'cd '.getcwd()

" :EditSnippets for UltiSnips                                   {{{2
" NB there's already :UltiSnipsEdit
command! -nargs=? EditSnippets
  \ exe ":sp ~/.vim/UltiSnips/"
  \     . (<q-args> != "" ? <q-args> : &ft != "" ? &ft : "all") . ".snippets"

" :EditFiletypePlugin                                           {{{2
command! -nargs=? EditFiletypePlugin
  \ exe ":sp ~/.vim/ftplugin/"
  \     . (<q-args> != "" ? <q-args> : &ft) . ".vim"

" :EditSyntaxPlugin                                             {{{2
command! -nargs=? EditSyntaxPlugin
  \ exe ":sp ~/.vim/syntax/"
  \     . (<q-args> != "" ? <q-args> : &ft) . ".vim"

" :EditIndentPlugin                                             {{{2
command! -nargs=? EditIndentPlugin
  \ exe "sp ~/.vim/indent/"
  \     . (<q-args> != "" ? <q-args> : &ft) . ".vim"

" :EditMacro as alias for :MacroEdit because my brain works that way
command! -nargs=1 EditMacro MacroEdit <args>

" :EditTestSwitcher                                             {{{2
command! EditTestSwitcher :e ~/.vim/test-switcher.cfg

" :EditTestRunner                                               {{{2
command! EditTestRunner :e ~/.vim/py-test-runner.cfg

" :EditPythonImports                                            {{{2
command! EditPythonImports :e ~/.vim/python-imports.cfg

" :ReloadFtdetectScripts after editing a ~/.vim/ftdetect/*.vim  {{{2
command! -bang ReloadFtdetectScripts :unlet did_load_filetypes | runtime filetype.vim

" :ReloadPlugin name                                            {{{2
command! -nargs=? -complete=custom,mg#reload#complete
            \ ReloadPlugin :call mg#reload#plugin(<f-args>)

" :EditPlugin name
command! -nargs=? -complete=custom,mg#reload#complete
          \ EditPlugin :exec 'e ' .. mg#reload#path_of(<q-args>) .. '/'

" :EditAutoload name
command! -nargs=? -complete=custom,mg#autoload#complete
          \ EditAutoload :exec 'e ' .. mg#autoload#path_of(<q-args>)

" :Python3 and :Python2 to toggle Syntastic/flake8 mode         {{{2

function! Flake8(exe, args, recheck_now)
  let g:ale_python_flake8_executable = a:exe
  let g:ale_python_flake8_options = a:args
  let g:syntastic_python_flake8_exe = a:exe . ' ' . a:args
  if a:recheck_now && exists(':SyntasticCheck')
    SyntasticCheck
  endif
  if a:recheck_now && exists(':ALELint')
    ALELint
  endif
endf
function! Python2(recheck_now)
  call Flake8('python2', '-m flake8', a:recheck_now)
  let g:coverage_script = 'python2 -m coverage'
endf
function! Python3(recheck_now)
  " I prefer to pipx install flake8 and coverage
  call Flake8('flake8', '', a:recheck_now)
  let g:coverage_script = 'coverage'
endf
command! -bar Python2 call Python2(1)
command! -bar Python3 call Python3(1)

" :MyPy enables Python type checking                            {{{2

command! -bar -nargs=?  MyPy      call mg#python#mypy_on(<q-args>)
command! -bar           MyPyOff   call mg#python#mypy_off()

" :Ruff switches from flake8 to ruff                            {{{2
command! -bar           Ruff      call mg#python#ruff()
command! -bar           Flake8    call mg#python#flake8()

" :ESLint/:JSHint to tell Syntastic what to use for js          {{{2

command! -bar ESLint  let g:syntastic_javascript_checkers = ['eslint'] | SyntasticCheck
command! -bar JSHint  let g:syntastic_javascript_checkers = ['jshint'] | SyntasticCheck

" :MakeCommand <command>                                        {{{2
command -bar -nargs=* MakeCommand
      \ let &makeprg = <q-args> | set makeprg

" :MakeTarget [<target>]                                        {{{2
command -bar -nargs=* MakeTarget
      \ let &makeprg = join(["make", <f-args>], ' ') | set makeprg

" :TermRestart -- re-exec the terminal command that exited      {{{2
augroup TermRestart
  au!
  if exists("##TerminalOpen")
    " vim 8.0.1789 does not emit BufWinEnter for terminal windows
    au TerminalOpen * command! -buffer TermRestart exec 'term ++curwin' expand("%")[1:]
    au TerminalOpen * map <buffer> <F5> :TermRestart<CR>
  else
    au BufWinEnter * if &buftype == 'terminal'
    au BufWinEnter *   command! -buffer TermRestart exec 'term ++curwin' expand("%")[1:]
    au BufWinEnter * endif
  endif
augroup END

endif " has("user_commands")

"
" Keyboard macros                                               {{{1
"

" Ctrl-L loads changed files, updates diff, recomputes folds    {{{2
function! s:RedrawCommand()
    let s = ':checktime'
    if &diff
        let s .= '|diffupdate'
    endif
    if exists(':GitGutter')
        let s .= '|GitGutter'
    endif
    if exists(':ALELint')
        let s .= '|ALELint'
    endif
    if exists('*mg#statusline_update')
        let s .= '|call mg#statusline_update()'
    endif
    let s .= "\<CR>"
    let s .= 'zx'
    return s . "\<C-L>"
endf
noremap <silent> <expr> <C-L>   <SID>RedrawCommand()

" Alt-. inserts last word from previous line                    {{{2

inoremap        <Esc>.          <C-R>=split(getline(line(".")-1))[-1]<CR>

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

" An 'all string' text object w/o surrounding whitespace        {{{2

omap            a'              2i'
omap            a"              2i"
vmap            a'              2i'
vmap            a"              2i"

" Diffget/diffput in visual mode                                {{{2

vmap            \do             :diffget<CR>
vmap            \dp             :diffput<CR>

" S-Insert pastes                                               {{{2
map!            <S-Insert>      <MiddleMouse>

" gV selects the just-pasted text                               {{{2
nnoremap <expr> gV              "`[" . getregtype() . "`]"

" p preserves the unnamed register/clipboard in visual mode     {{{2
vnoremap <expr> p  mg#vp#mapping()

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
map             ,3              <F3>
map             ,4              <F4>
map             ,5              <F5>
map             ,6              <F6>
if exists("$TERMUX_VERSION")
  imap            ,,              <ESC>
endif

" open a file in the same dir as the current one                {{{2
map <expr>      ,E              ":e ".mg#curdir#get()."/"

" open a file with same basename but different extension        {{{2
map <expr>      ,R              ":e ".expand("%:r")."."

" close just the deepest level of folds                         {{{2
map             ,zm             zRzm

" Slower mouse wheel scrolling in terminals                     {{{2
" for some reason regular scrolls get interpreted as <C-ScrollWheelUp/Down> in
" VTE terminals
map             <C-ScrollWheelUp>   <C-Y>
map             <C-ScrollWheelDown> <C-E>

" Scrolling with Ctrl+Up/Down                                   {{{2
map             <C-Up>          1<C-U>
map             <C-Down>        1<C-D>
imap            <C-Up>          <C-O><C-Up>
imap            <C-Down>        <C-O><C-Down>

" Moving around with Shift+Up/Down                              {{{2
map             <S-Up>          {
map             <S-Down>        }
imap            <S-Up>          <C-O><S-Up>
imap            <S-Down>        <C-O><S-Down>

" Navigating around windows without releasing Ctrl              {{{2
map             <C-W><C-Up>     <C-W><Up>
map             <C-W><C-Down>   <C-W><Down>
map             <C-W><C-Left>   <C-W><Left>
map             <C-W><C-Right>  <C-W><Right>

" Navigating around windows with Ctrl+Shift+arrows              {{{2
map             <C-S-Up>        <C-W><Up>
map             <C-S-Down>      <C-W><Down>
map             <C-S-Left>      <C-W><Left>
map             <C-S-Right>     <C-W><Right>
map!            <C-S-Up>        <C-O><C-W><Up>
map!            <C-S-Down>      <C-O><C-W><Down>
map!            <C-S-Left>      <C-O><C-W><Left>
map!            <C-S-Right>     <C-O><C-W><Right>
if has("terminal")
  tmap            <C-S-Up>        <C-W><Up>
  tmap            <C-S-Down>      <C-W><Down>
  tmap            <C-S-Left>      <C-W><Left>
  tmap            <C-S-Right>     <C-W><Right>
endif

" History scrolling in terminal windows with Shift+PageUp/Down  {{{2
if has("terminal")
  tnoremap        <S-PageUp>        <C-W>N<PageUp>
  tnoremap        <S-PageDown>      <C-W>N<PageDown>
endif

" Jumping to lint errors with Ctrl-J/K                          {{{2
nmap <silent>   <C-K>           <Plug>(ale_previous)
nmap <silent>   <C-J>           <Plug>(ale_next)

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

" also Alt+PageUp/PageDown
nnoremap <A-PageUp> gT
nnoremap <A-PageDown> gt
inoremap <A-PageUp> <C-O>gT
inoremap <A-PageDown> <C-O>gt

" Switching tabs with <C-W><A-number> in terminal mode          {{{2
if has("terminal")
  for s:nr in range(1, 9)
    exec 'tnoremap <C-W><A-'.s:nr.'> <C-W>:tabnext '.s:nr.'<CR>'
    exec 'tnoremap <C-W><Esc>'.s:nr.'> <C-W>:tabnext '.s:nr.'<CR>'
  endfor
  " also Alt+PageUp/PageDown
  tnoremap <A-PageUp> <C-W>gT
  tnoremap <A-PageDown> <C-W>gt
endif

" Sending Ctrl-W to the program running in the terminal         {{{2
if has("terminal")
  tnoremap      <C-W><Space>    <C-W>.
endif

" Emacs style command line                                      {{{2
cnoremap        <C-G>           <C-C>
cnoremap        <C-A>           <Home>

" Alt+b,f move word backwards/forwards
cnoremap        <Esc>b          <S-Left>
cnoremap        <Esc>f          <S-Right>

" Alt+Left/Right move word backwards/forwards
cnoremap        <M-Left>        <S-Left>
cnoremap        <M-Right>       <S-Right>

" Alt+d delete word
cnoremap        <Esc>d  <C-\>emg#edit_cmdline#delete_word()<CR>

" ^K deletes to end of line
cnoremap        <C-K>   <C-\>emg#edit_cmdline#delete_to_eol()<CR>

" Alt-Backspace deletes word backwards
cnoremap        <A-BS>          <C-\>emg#edit_cmdline#delete_word_backwards()<CR>
cnoremap        <Esc><BS>       <C-\>emg#edit_cmdline#delete_word_backwards()<CR>

" Ctrl-Backspace deletes word backwards
cnoremap        <C-BS>          <C-W>
" (gnome-terminal sends ^H for ctrl-backspace)
cmap            <C-H>           <C-BS>

" Do not lose "complete all" (gvim-only)
cnoremap        <C-S-A>         <C-A>

" Insert line under cursor (builtin in vim 8.0.1787)
cnoremap        <C-R><C-L>      <C-R>=getline(".")<CR>

" Insert the file name (the tail portion) of the current buffer
cnoremap        <C-R><C-T>      <C-R>=expand("%:t")<CR>

" Insert the contents of the / register without \< \> with C-R C-/
cnoremap        <C-R><C-_>      <C-R>=substitute(@/, '\\[<>]', '', 'g')<CR>

" Windows style editing                                         {{{2
imap            <C-Del>         <C-O>dw
imap            <C-kDel>        <C-O>dw
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
" usually I want :wall, to save all buffers -- but if there's a scratch buffer
" that cannot be saved for silly reasons (like it hasn't been named), then at
" least please save the current buffer, or I'll be sad.
map             <F2>            :update<bar>wall<CR>
imap            <F2>            <C-O><F2>

" <F3> = turn off search highlighting
map             <F3>
      \ :nohlsearch<bar>call ResetStatusLineColor()<bar>GitGutter<CR>
imap            <F3>            <C-O><F3>

" <S-F3> = turn off location list
map             <S-F3>          :lclose<CR>
imap            <S-F3>          <C-O><S-F3>

" <C-F3> = turn off quickfix
map             <C-F3>          :cclose<CR>
imap            <C-F3>          <C-O><C-F3>

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
map             <F8>            :let @/='\<'.expand('<cword>').'\>'<bar>let @*=expand('<cword>')<bar>set hls<bar>call mg#show#search_count()<CR>
imap            <F8>            <C-O><F8>
vnoremap        <F8>
      \ y:let @/='\V'.substitute(escape(@@,"/\\"),"\n","\\\\n","ge")<bar>set hls<bar>call mg#show#search_count()<CR>

" <F9> = make (often overwritten by filetype plugins)
map             <F9>    :VerboseMake<CR>
imap            <F9>    <C-O><F9>
" <S-F9> = toggle quickfix window
map             <S-F9>  :call asyncrun#quickfix_toggle(8)<bar>call mg#statusline_update()<CR>
imap            <S-F9>  <C-O><S-F9>

" <F10> = quit
" (some file-type dependent autocommands redefine it)
""map           <F10>           :q<CR>
""imap          <F10>           <ESC>

" <S-F10> = toggle NERDTree
map             <S-F10>         :NERDTreeToggle<CR>
imap            <S-F10>         <C-O><S-F10>

" <F11> = toggle 'paste'
set pastetoggle=<F11>

" <F12> = show the Unicode name of the character under cursor
" I used to have my own :UnicodeName for this, but tpope/vim-characterize is
" better
map             <F12>           <Plug>(characterize)
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
  au BufReadPost *
    \ let line = line("'\"")
    \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
    \      && index(['xxd', 'gitrebase'], &filetype) == -1
    \ |   execute "normal! g`\""
    \ | endif
augroup END

" Create missing directory on save                              {{{2
augroup MkDirOnSave
  au!
  au BufWritePre * call mg#mkdir#ondemand()
augroup END

" Autodetect filetype on first save                             {{{2
augroup FiletypeOnSave
  au!
  au BufWritePost * if &ft == "" | filetype detect | endif
augroup END

" chmod +x on save                                              {{{2
augroup MakeExecutableOnSave
  " https://unix.stackexchange.com/questions/39982/vim-create-file-with-x-bit
  " See also http://vim.wikia.com/wiki/Setting_file_attributes_without_reloading_a_buffer
  au!
  au BufWritePost * call mg#chmodx#doit()
augroup END

" Make fugitive's fake buffers visually distinguishable         {{{2
augroup MakeFugitiveVisible
  au!
  au BufNew,BufReadPost fugitive://* Margin 0
  au FileType floggraph              MarginOff
augroup END

" Avoid editing files inside .tox/*/lib/*/site-packages         {{{2
augroup AvoidEditsUnderTox
  au!
  au BufReadPost */.tox/*/python*/site-packages/* setlocal readonly
augroup END

" focus the 1st py.test failure in quickfix                     {{{2
augroup QuickfixStatus
  au!
  au BufWinEnter quickfix call FocusOnTestFailure()
augroup END

function! FocusOnTestFailure()
  let idx = 0
  for d in getqflist()
    let idx += 1
    " py.test output has error messages starting with "E "; the filename and
    " line number follow a few lines down and I can jump there with :cn,
    " but I'd like to see the error message first
    if d.module == "" && d.text =~ "^E "
      " silent! because sometimes I get E788: Not allowed to edit another
      " buffer now, when this is invoked from g:asyncrun_exit
      silent! exec "cc" idx
      break
    endif
  endfor
endf

" Programming in Python                                         {{{2

function! FT_Python_Ivija()
  setlocal wildignore+=docs/src/*  " make command-t ignore the duplicated subtree
  setlocal wildignore+=reportgen-output/*
  let g:ale_linters.xml = []
  let g:coverage_script = 'bin/coverage'
  let g:coverage_script_args = ''
endf

function! FT_Python_Django()
  setlocal wildignore+=var/www/static/*
endf

function! FT_Tilaajavastuu()
  let g:source_locator_prefixes = ['db/', 'server/', 'robottests/', 'client/', 'src/']
  let g:source_locator_suffixes = ['.py', '.txt', '.robot']
  let g:black_macchiato_args = "-S -l100"
endf

function! FT_Bolagsfakta_Syntastic()
  set wildignore+=*/server/var,*/build,*/pkgbuild
  call Python3(0)
  let g:ale_javascript_eslint_executable = 'client/eslint'
  " the only problem is that :ALEFix takes ***ages*** on a 1000-line .jsx,
  " when the equivalent command-line :!prettier --write % takes milliseconds
  if filereadable('client/node_modules/.bin/prettier')
    let g:ale_javascript_prettier_executable = 'client/node_modules/.bin/prettier'
    let g:ale_javascript_prettier_options = '--parser babel'
  else
    let g:ale_javascript_prettier_executable = 'prettier'
    let g:ale_javascript_prettier_options = ''
  endif
  let g:ale_python_mypy_executable = 'server/env/bin/mypy'
  let g:syntastic_javascript_eslint_exec = 'client/eslint'
  let g:syntastic_javascript_checkers = ['eslint']
  let g:coverage_script = 'server/env/bin/coverage'
  let g:source_locator_prefixes = ["server/"]
  if executable('./.ctags-wrapper')
    let g:gutentags_ctags_executable = fnamemodify('./.ctags-wrapper', ':p')
  endif
  Margin 100
  fun! RandomQvarnID()
    pyx import random
    return pyxeval('"%04x-%032x-%08x" % (random.randrange(16**4), random.randrange(16**32), random.randrange(16**8))')
  endf
  fun! RandomUUID()
    pyx import uuid
    return pyxeval('str(uuid.uuid4())')
  endf
endf

augroup Python_prog
  autocmd!
  autocmd BufRead,BufNewFile ~/src/ivija/**/*.txt  set ft=rst
  autocmd BufRead,BufNewFile ~/src/ivija/**/*.tt   set ft=xml | Margin 44
  autocmd BufRead,BufNewFile *  if expand('%:p') =~ 'ivija' | call FT_Python_Ivija() | endif
  autocmd BufRead,BufNewFile *  if expand('%:p') =~ 'labtarna' | call FT_Python_Django() | endif
  autocmd BufReadPre,BufNewFile **/tilaajavastuu/bol*/**/* call FT_Bolagsfakta_Syntastic()
  autocmd BufReadPre,BufNewFile **/tilaajavastuu/**/* call FT_Tilaajavastuu()
  autocmd BufReadPre,BufNewFile **/tilaajavastuu/bol*/**/*.html setlocal sw=4
  if getcwd() =~ '.*tilaajavastuu.*' | call FT_Bolagsfakta_Syntastic() | endif
  if getcwd() =~ '.*tilaajavastuu.*' | call FT_Tilaajavastuu() | endif
augroup END

augroup JS_prog
  autocmd!
  autocmd FileType javascript,typescript  map <buffer> <C-F6>  :SwitchCodeAndTest<CR>
augroup END

function! FT_Mako()
  set ft=html
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
        setlocal ft=rst
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
  setlocal path^=src/bookserv/templates,src/bookserv/public
  setlocal includeexpr=substitute(v:fname,'^/','','')
endf

augroup BookServ
  autocmd!
  autocmd BufRead,BufNewFile ~/src/bookserv/*.py        call FT_BookServ_Py()
augroup END

" JavaScript                                                    {{{2

augroup JavaScript
  autocmd!
  " fdm=syntax is Very Slow for multi-thousand-line-long JSON files
  autocmd BufReadPre,BufNewFile *.json                  set fdm=indent
augroup END

" Ansible roles                                                 {{{2

augroup Ansible
  autocmd!
  autocmd BufReadPre,BufNewFile */roles/*/*.yml
              \ let &l:path = expand("%:p:h:h")."/**,".&g:path
augroup END

" .vimrc                                                        {{{2

augroup VimRc
  autocmd!
  autocmd BufReadPre,BufNewFile ~/.vimrc,~/.vim/*
              \ setlocal path=~/.vim/** includeexpr=substitute(v:fname,'^.*/','','')
augroup END

" autosave on focus loss                                        {{{2

augroup Focus
  autocmd!
  autocmd FocusLost * silent! wall
  autocmd FocusGained * checktime
augroup END

endif " has("autocmd")

"
" Colors                                                        {{{1
"

if has("gui_running")
  gui                           " see :help 'background' why I need this before
  set t_vb=                     " this must be set after :gui
elseif exists("$LC_VIM_BACKGROUND")
  " vim has terminal background color detection, but it's unreliable
  " and also causes flashing, so I set a custom env var in my .bashrc to
  " force a specific vim background color.  The variable is called LC_xxx
  " so that ssh will forward it to remote machines.
  let &background = $LC_VIM_BACKGROUND
endif


if has("syntax") && !exists("g:syntax_on")
  syntax enable
endif

" My colour overrides
" (TBH I should be putting these in a function and calling it from a
" ColorScheme autocommand, but meh, it's easy enough to do a ,s when my colors
" get stomped over)

fun! MyColorTweaks()

  highlight NonText               ctermfg=gray guifg=gray term=standout
  highlight SpecialKey            ctermfg=8 guifg=gray term=standout
  highlight SpellBad              cterm=underline ctermfg=red ctermbg=NONE
  highlight SpellCap              cterm=underline ctermfg=blue ctermbg=NONE

  if &background == "dark"
    highlight MatchParen            gui=bold guibg=NONE guifg=lightblue cterm=bold ctermbg=232
  else
    highlight MatchParen            gui=bold guibg=NONE guifg=lightblue cterm=bold ctermbg=255
  endif

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

  " for custom :match commands
  highlight Red                   guibg=red ctermbg=red
  highlight Green                 guibg=green ctermbg=green

  " for less intrusive signs
  if &background == "dark"
    highlight SignColumn ctermbg=235 guibg=#262626
  else
    highlight SignColumn ctermbg=230 guibg=#ffffd7
  endif
  if exists("*gitgutter#highlight#define_highlights")
    " let vim-gitgutter know we changed the SignColumn colors!
    call gitgutter#highlight#define_highlights()
  endif

  if &background == "dark"
    hi ALEErrorSign ctermfg=red ctermbg=235
    hi ALEWarningSign ctermfg=202 ctermbg=235
    hi ALEVirtualTextError ctermfg=9 ctermbg=235
    hi link ALEVirtualTextWarning ALEVirtualTextError
  else
    hi ALEErrorSign ctermfg=red ctermbg=230 guibg=#ffffd7
    hi ALEWarningSign ctermfg=202 ctermbg=230 guibg=#ffffd7
  endif

  if &background == "dark"
    hi GitGutterAdd ctermfg=70 ctermbg=235
    hi GitGutterChange ctermfg=208 ctermbg=235
    hi GitGutterDelete ctermfg=160 ctermbg=235
  else
    hi GitGutterAdd ctermfg=70 ctermbg=230
    hi GitGutterChange ctermfg=208 ctermbg=230
    hi GitGutterDelete ctermfg=160 ctermbg=230
  endif

  " gutter on the right of the text
  if &background == "dark"
    highlight ColorColumn ctermbg=233 guibg=#121212
  else
    highlight ColorColumn ctermbg=230 guibg=#ffffd7
  endif

  " gutter below the text
  if &background == "dark"
    highlight NonText ctermbg=233 guibg=#121212
  else
    highlight NonText ctermbg=230 guibg=#ffffd7
  endif
  set shortmess+=I " suppress intro message because the above makes it look bad

  " fold column aka gutter on the left
  if &background == "dark"
    highlight FoldColumn ctermbg=235 guibg=#262626
  else
    highlight FoldColumn ctermbg=230 guibg=#ffffd7
  endif

  " number column aka gutter on the left
  if &background == "dark"
    highlight LineNr ctermfg=11 ctermbg=235 guibg=#262626
    highlight CursorLineNr ctermbg=235 guibg=#262626 cterm=underline
  else
    highlight LineNr ctermbg=230 guibg=#ffffd7
    highlight CursorLineNr ctermbg=230 guibg=#ffffd7 cterm=underline
  endif

  " cursor column
  if &background == "dark"
    highlight CursorColumn ctermbg=235 guibg=#262626
    highlight CursorLine ctermbg=235 guibg=#262626 cterm=NONE
  else
    highlight CursorColumn ctermbg=230 guibg=#ffffd7
    highlight CursorLine ctermbg=230 guibg=#ffffd7 cterm=NONE
  endif

  " avoid invisible color combination (red on red)
  highlight DiffText ctermbg=203

  " easier on the eyes
  if &background == "dark"
    highlight Folded ctermbg=234
  else
    highlight Folded ctermbg=229 guibg=#ffffaf
  endif

  set fillchars=vert:│,fold:-
  if &background == "dark"
    highlight VertSplit cterm=NONE ctermbg=235
  else
    highlight VertSplit cterm=reverse ctermbg=7
  endif

  " indicate test status
  if &background == "dark"
    hi StatusLineNeutral ctermfg=237
  endif
  hi StatusLineNeutral
              \ term=bold,reverse cterm=bold,reverse gui=bold,reverse
  hi StatusLineRunning ctermfg=53 guifg=#5f005f
              \ term=bold,reverse cterm=bold,reverse gui=bold,reverse
  hi StatusLineSuccess ctermfg=22 guifg=#005f00
              \ term=bold,reverse cterm=bold,reverse gui=bold,reverse
  hi StatusLineFailure ctermfg=52 guifg=#5f0000
              \ term=bold,reverse cterm=bold,reverse gui=bold,reverse
  hi! link StatusLine StatusLineNeutral
  call mg#statusline_highlight()
endf
call MyColorTweaks()

augroup MyColorTweaks
  au!
  au ColorScheme * call MyColorTweaks()
  au OptionSet background call MyColorTweaks()
augroup END


"
" Toolbar buttons                                               {{{1
"

if !exists("did_install_mg_menus") && has("gui")
  let did_install_mg_menus = 1
  " NB: these have icons in bitmaps/*.png.
  amenu 1.200   ToolBar.-Sep700-        :
  amenu 1.201   ToolBar.TrimSpaces      :NukeTrailingWhitespace<CR>
  tmenu         ToolBar.TrimSpaces      Remove trailing whitespace
  amenu 1.202   ToolBar.ToggleHdr       <C-F6>
  tmenu         ToolBar.ToggleHdr       Switch between source and header (C/C++), or code and test (Python)
endif
