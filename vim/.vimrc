" enbroding
set nocompatible
set encoding=utf-8
set fileencoding=utf-8
filetype off

" plugggggedin
" set the runtime path to include fzf and initialize vim plugged
set rtp+=~/.fzf,~/.vim/plugged
call plug#begin('~/.vim/plugged')

" tmp f0rk 4: Plug 'ervandew/supertab'
Plug 'metalelf0/supertab'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'mbbill/undotree'
Plug 'edkolev/tmuxline.vim'
Plug 'fatih/vim-go'
Plug 'matze/vim-move'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-eunuch'
Plug 'tomtom/tcomment_vim'
Plug 'airblade/vim-gitgutter'
Plug 'hashivim/vim-terraform'
Plug 'hashivim/vim-packer'
Plug 'townk/vim-autoclose'
Plug 'vim-scripts/ZoomWin'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mustache/vim-mustache-handlebars'
Plug 'potatoesmaster/i3-vim-syntax'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'zah/nim.vim'
Plug 'Chiel92/vim-autoformat'

call plug#end()

" history
set history=10000
set undolevels=1000

" colours
filetype plugin indent on
syntax on
" syntax enable
au FileType gitcommit setlocal tw=72
au BufNewFile,BufRead Jenkinsfile setf groovy
au BufNewFile,BufRead *.tpl setlocal filetype=mustache

let g:solarized_termcolors=256
set background=dark
if &diff
    colorscheme solarized
endif

" backspace
set backspace=indent,eol,start

" vsp style
set fillchars+=vert:\│
hi VertSplit ctermfg=Black ctermbg=DarkGray
hi clear TODO
hi Todo ctermfg=DarkGrey guifg=DarkGrey guibg=DarkGrey
highlight Pmenu ctermbg=gray guibg=gray

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
set splitbelow splitright

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
hi clear SpellBad
hi clear SpellCap
hi clear SpellRare
hi clear SpellLocal
hi SpellBad term=underline cterm=underline term=standout ctermfg=1
hi SpellCap term=underline cterm=underline
hi SpellRare term=underline cterm=underline
hi SpellLocal term=underline cterm=underline
hi CursorLine gui=NONE cterm=NONE ctermbg=236 guibg=#32322f
hi CursorLineNr term=bold cterm=bold ctermfg=012 gui=bold

" vim-move
let g:move_key_modifier = 'C'

" editorconfig
" let g:EditorConfig_core_mode = 'external_command'
let g:EditorConfig_exec_path = '/usr/bin/editorconfig'

" nerdTREE
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$']

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

nnoremap <F6> :NERDTreeToggle<CR>
nmap <C-p> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" undoTREE
nnoremap <F5> :UndotreeToggle<cr>

" markDOWN
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_autowrite = 1

" tMUX
" 1 :update, 2 :wall
let g:tmux_navigator_save_on_switch = 1
let g:tmux_navigator_disable_when_zoomed = 1

" fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'
let $FZF_DEFAULT_OPTS = '--bind up:preview-up,down:preview-down'
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \ 'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
map ;f :FZF<CR>
map ;w :Rg<CR>
map ;b :Buffers<CR>
map ;c :Commits<CR>
map ;h :History:<CR>
map ;t :Filetypes<CR>
map ;s :Snippets<CR>
map ;a :Locate<space>

" SUPAtab
let g:SuperTabDefaultCompletionType = "<c-n>"

" snipsnip
let g:UltiSnipsExpandTrigger = "<c-y>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" gIt
set foldlevelstart=99

" redraw
map ;l :redraw!<CR>

" gOlAnG
let g:go_template_autocreate = 0
let g:go_highlight_structs = 1
let g:go_highlight_methods = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_contrants = 1
let g:go_def_mapping_enabled = 0
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

" oPa
let g:formatdef_rego = '"opa fmt"'
let g:formatters_rego = ['rego']
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
au BufWritePre *.rego Autoformat
let g:autoformat_verbosemode = 1

" tmux statusbar
let g:tmuxline_powerline_separators = 0
let g:tmuxline_preset = {
    \ 'a': '#S',
    \ 'b': ['#(whoami)', '#(uptime | cut -d " " -f 3,4,5,6,7 | sed "s/,$//")'],
    \ 'c': '#(/bin/bash ~/.tmux/kube-tmux/kube.tmux 250 red cyan)',
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

" spelling mistakes
command! -bang E e<bang>
command! -bang Q q<bang>
command! -bang W w<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>

" sudowrite
cnoremap w!! w !sudo tee % >/dev/null

" generate ctags
command! MakeTags :call MakeTags()

function! MakeTags()
    exe 'silent !ctags -a -R . 2>/dev/null'
    exe 'redraw!'
endfunction

" snippets or some resemblance of them :>
" go
nnoremap ,gobp :-1read $HOME/Dropbox/vim/snippets/goboilerplate.go<CR>6jwf)a

" k8s
nnoremap ,k8dpl :-1read $HOME/Dropbox/vim/snippets/k8s-deployment.yaml<CR>6jwf)a
nnoremap ,k8svc :-1read $HOME/Dropbox/vim/snippets/k8s-service.yaml<CR>6jwf)a
nnoremap ,k8ds :-1read $HOME/Dropbox/vim/snippets/k8s-daemonset.yaml<CR>6jwf)a
nnoremap ,k8cm :-1read $HOME/Dropbox/vim/snippets/k8s-configmap.yaml<CR>6jwf)a
nnoremap ,k8secret :-1read $HOME/Dropbox/vim/snippets/k8s-secret.yaml<CR>6jwf)a

" keyMaps
nnoremap ; :
nnoremap <esc><esc> :noh<return>
vnoremap <C-c> "+y

if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[5 q"
endif

function! GitBranch()
    return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
    let l:branchname = GitBranch()
    return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

function TrimWhitespace()
  %s/\s*$//
  ''
:endfunction
command! Trim call TrimWhitespace()

" run `xrdb -merge` whenever Xdefaults or Xresources are updated
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb -merge %

" run `killall dunst` whenever ~/.config/dunst/dunstrc is updated
autocmd BufWritePost ~/.config/dunst/dunstrc !killall dunst

" run `i3-msg restart` whenever ~/.config/i3/config is updated
autocmd BufWritePost ~/.config/i3/config !i3-msg restart

" coc.vim & LS
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=100

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gb <C-o>

" Use U to show documentation in preview window
nnoremap <silent> U :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" Enter = Ctrl + Y
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

" nim
fun! JumpToDef()
  if exists("*GotoDefinition_" . &filetype)
    call GotoDefinition_{&filetype}()
  else
    exe "norm! \<C-]>"
  endif
endf

" Jump to tag
nn <M-g> :call JumpToDef()<cr>
ino <M-g> <esc>:call JumpToDef()<cr>i

" shift + 8 to search for selected text: https://salferrarello.com/vim-visual-mode-search-selection/
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
