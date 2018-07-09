" vundle
set nocompatible
filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim,~/.fzf
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'edkolev/tmuxline.vim'
Plugin 'fatih/vim-go'
Plugin 'matze/vim-move'
Plugin 'valloric/youcompleteme'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-eunuch'
Plugin 'tomtom/tcomment_vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'hashivim/vim-terraform'
Plugin 'townk/vim-autoclose'
Plugin 'ZoomWin'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'christoomey/vim-tmux-navigator'

call vundle#end()
filetype plugin indent on

" history
set history=10000
set undolevels=1000

" colours
syntax enable
let g:solarized_termcolors=256
set background=dark
colorscheme solarized

" backspace
set backspace=indent,eol,start

" UI
set ttyfast
set mouse=a
set number
set showmode
set showcmd
set cursorline
set wildmenu
set wildmode=list:full
set wildignore=*.swp,*.bak,*.pyc,*.class,~*
set lazyredraw
set showmatch
set ruler
set wrap
set guicursor+=a:blinkon0

" auto
set autoread
set autowrite
set autowriteall
set autochdir

" search
set incsearch
set hlsearch
set ignorecase
set smartcase

" spelling
set spell
set spelllang=en_au
set spellfile=$HOME/Dropbox/vim/spell/en.utf-8.add

" vim-move
let g:move_key_modifier = 'C'

" editorconfig
let g:EditorConfig_core_mode = 'external_command'

" nerdTREE
let NERDTreeShowHidden=1

" markDOWN
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_autowrite = 1

" tMUX
" 1 :update, 2 :wall
let g:tmux_navigator_save_on_switch = 1
let g:tmux_navigator_disable_when_zoomed = 1

" fzf
map ;f :FZF<CR>
let $FZF_DEFAULT_COMMAND = 'find . -type f -not -path "*/\.git/*";'

" redraw
map ;l :redraw!<CR>

" gOlAnG
let g:go_template_autocreate = 0

" tmux statusbar
let g:tmuxline_powerline_separators = 0
let g:tmuxline_preset = {
    \ 'a': '#S',
    \ 'b': ['#(whoami)', '#(uptime | cut -d " " -f 3,4,5,6,7 | sed "s/,$//")'],
    \ 'c': '#W',
    \ 'win': ['#I', '#W'],
    \ 'cwin': ['#I', '#W'],
    \ 'x': '%a',
    \ 'y': ['%b %d', '%R'],
    \ 'z': '#H'}

let g:tmuxline_theme = {
    \   'a'    : [ 236, 103 ],
    \   'b'    : [ 253, 239 ],
    \   'c'    : [ 244, 236 ],
    \   'x'    : [ 244, 236 ],
    \   'y'    : [ 253, 239 ],
    \   'z'    : [ 236, 103 ],
    \   'win'  : [ 103, 236 ],
    \   'cwin' : [ 236, 103 ],
    \   'bg'   : [ 244, 236 ],
    \ }

" generate ctags
command! MakeTags :call MakeTags()

function! MakeTags()
    exe 'silent !ctags -a -R . 2>/dev/null'
    exe 'redraw!'
endfunction

nnoremap ,gobp :-1read $HOME/Dropbox/vim/snippets/goboilerplate.go<CR>6jwf)a

if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[5 q"
endif

map <C-o> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

function! GitBranch()
    return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
    let l:branchname = GitBranch()
    return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set laststatus=2
set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
