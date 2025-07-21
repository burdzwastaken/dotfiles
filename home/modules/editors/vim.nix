{ pkgs, ... }:

{
  programs.vim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      coc-nvim
      copilot-vim
      editorconfig-vim
      fzf-vim
      lexima-vim
      markdown-preview-nvim
      nerdtree
      nerdtree-git-plugin
      tabular
      tcomment_vim
      undotree
      vim-abolish
      vim-autoformat
      vim-devicons
      vim-eunuch
      vim-fugitive
      vim-gitgutter
      vim-go
      vim-helm
      vim-markdown
      vim-multiple-cursors
      vim-mustache-handlebars
      vim-nerdtree-syntax-highlight
      vim-nix
      vim-packer
      vim-rhubarb
      vim-snippets
      vim-startify
      vim-surround
      vim-terraform
      vim-toml
      vimwiki
    ];

    extraConfig = ''
      " ========== General Settings ==========
      set nocompatible
      set number
      set cursorline
      set ignorecase
      set ruler
      set wrap
      set showmode
      set showcmd
      set ttyfast
      set lazyredraw
      set showmatch
      set backspace=indent,eol,start
      set wildignore=*.swp,*.bak,*.pyc,*.class,~*
      set nobackup
      set nowritebackup
      set signcolumn=yes
      set cmdheight=2
      set shortmess+=c
      set updatetime=100
      set incsearch
      set hlsearch
      set spell
      set spelllang=en_au

      filetype off
      filetype plugin indent on
      syntax on

      " Encoding settings
      set encoding=utf-8
      set fileencoding=utf-8

      " History and undo settings
      set history=10000
      set undolevels=10000

      " Custom spelling file
      set spellfile=$HOME/Dropbox/vim/spell/en.utf-8.add

      " UI Appearance customizations
      " Color settings
      hi MatchParen cterm=bold ctermbg=none ctermfg=blue
      hi LineNr ctermfg=grey
      hi CursorColumn ctermbg=magenta

      " Set solarized color scheme in diff mode
      let g:solarized_termcolors=256
      set background=dark
      if &diff
          colorscheme solarized
      endif

      " GitGutter styling
      highlight! link SignColumn LineNr
      hi CursorLineNr guifg=#050505
      hi GitGutterAdd    guifg=#009900 guibg=NONE ctermfg=2 ctermbg=NONE
      hi GitGutterChange guifg=#bbbb00 guibg=NONE ctermfg=3 ctermbg=NONE
      hi GitGutterDelete guifg=#ff2222 guibg=NONE ctermfg=1 ctermbg=NONE

      " Vertical split styling
      set fillchars+=vert:\│
      hi VertSplit ctermfg=Black ctermbg=DarkGray
      hi clear TODO
      hi Todo ctermfg=DarkGrey guifg=DarkGrey guibg=DarkGrey
      highlight Pmenu ctermbg=gray guibg=gray

      " Spelling highlight customization
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

      " Search styling
      hi Search cterm=reverse

      " Status line styling
      hi StatusLine ctermfg=magenta ctermbg=NONE cterm=NONE

      " Coc menu styling
      hi CocSearch ctermfg=12 guifg=#18A3FF
      hi CocMenuSel gui=NONE cterm=NONE ctermbg=236 guibg=#32322f
      hi link CocFloating Normal

      " UI Settings
      set splitbelow splitright
      set wildmenu
      set wildmode=list:full
      set wim=longest:full,full
      set colorcolumn=0
      set showbreak=↪
      set sidescrolloff=5
      set scrolloff=5
      set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:·
      set nolist
      set laststatus=2
      set noshowmode
      set completeopt=menu,menuone,noselect
      set guicursor=a:ver100
      set guicursor+=a:blinkon0

      " Auto settings
      set autoread
      set autowrite
      set autowriteall

      " ========== Leader Key ==========
      let mapleader = ","
      let g:mapleader = ","

      " ========== Plugin Settings ==========
      " vim-move
      let g:move_key_modifier = 'C'

      " EditorConfig
      let g:EditorConfig_exec_path = '/usr/bin/editorconfig'

      " NERDTree
      let NERDTreeWinPos = "left"
      " Auto close NERDTree when it's the last window
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

      let NERDTreeShowHidden=1
      let NERDTreeIgnore=['\.vim$', '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$']

      " NERDTree Git plugin
      let g:NERDTreeGitStatusIndicatorMapCustom = {
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

      " NERDTree mappings
      nnoremap <F6> :NERDTreeToggle<CR>
      nmap <C-p> :NERDTreeToggle<CR>

      " UndoTree
      nnoremap <F5> :UndotreeToggle<cr>

      " Change split orientation
      map <Leader>tv <C-w>t<C-w>H
      map <Leader>th <C-w>t<C-w>K

      " Markdown
      let g:vim_markdown_folding_disabled = 1
      let g:vim_markdown_autowrite = 1
      au BufRead,BufNewFile *.md setlocal textwidth=80

      " Markdown preview
      nmap <F7> <Plug>MarkdownPreviewToggle

      " X-ray settings
      let g:xray_force_redraw = 1

      " FZF settings
      let g:fzf_layout = { 'down': '~40%' }

      autocmd! FileType fzf set laststatus=0 noshowmode noruler
        \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

      let g:fzf_command_prefix = 'Fzf'
      let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!*.swp"'
      let $FZF_DEFAULT_OPTS = '--info=inline --marker=">" --pointer=">" --no-multi-line --bind up:preview-up,down:preview-down '

      " Custom FZF commands
      command! -bang FzfDotfiles call fzf#vim#files('~/src/dotfiles', fzf#vim#with_preview(), <bang>0)
      command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \ 'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1,
        \   <bang>0 ? fzf#vim#with_preview('up:60%')
        \           : fzf#vim#with_preview('right:50%:hidden', '?'),
        \   <bang>0)

      " FZF mappings
      map ;f :FZF<CR>
      map ;w :FzfRg<CR>
      map ;b :FzfBuffers<CR>
      map ;c :FzfCommits<CR>
      map ;h :FzfHistory:<CR>
      map ;t :FzfFiletypes<CR>
      map ;a :FzfLocate<space>
      map ;/ :FzfHistory/<CR>
      map ;m :FzfMaps<CR>
      map ;d :FzfDotfiles<CR>
      map ;j :FzfTags<CR>
      map ;r :FzfCommands<CR>

      " Insert mappings
      map <F2> i<CR>
      map ;i i<CR><ESC>

      " SuperTab settings
      let g:SuperTabDefaultCompletionType = "<c-n>"
      let g:SuperTabCrMapping = 0

      " Git settings
      set foldlevelstart=99

      " Redraw mapping
      map ;l :redraw!<CR>

      " Go settings
      let g:go_template_autocreate = 0
      let g:go_highlight_structs = 1
      let g:go_highlight_methods = 1
      let g:go_highlight_types = 0
      let g:go_highlight_functions = 1
      let g:go_highlight_function_calls = 0
      let g:go_highlight_operators = 1
      let g:go_highlight_build_contrants = 1
      let g:go_highlight_function_parameters = 0
      let g:go_highlight_format_strings = 1
      let g:go_def_mapping_enabled = 0
      let g:go_fmt_command = "goimports"
      let g:go_auto_type_info= 1

      " GitGutter settings
      let g:gitgutter_realtime = 0

      " Common typo corrections
      command! -bang E e<bang>
      command! -bang Q q<bang>
      command! -bang W w<bang>
      command! -bang QA qa<bang>
      command! -bang Qa qa<bang>
      command! -bang Wa wa<bang>
      command! -bang WA wa<bang>
      command! -bang Wq wq<bang>
      command! -bang WQ wq<bang>

      " Tag generation command
      command! MakeTags :call MakeTags()

      function! MakeTags()
          exe 'silent !ctags -a -R . 2>/dev/null'
          exe 'redraw!'
      endfunction

      " Key mappings
      nnoremap <esc><esc> :noh<return>
      " vnoremap <C-c> "+y (nonwayland)
      vnoremap <C-c> :w !wl-copy<CR><CR>
      vnoremap <leader>64 y:echo system('base64 --decode', @")<cr>

      " File type settings
      au FileType gitcommit setlocal tw=72
      au BufNewFile,BufRead Jenkinsfile setf groovy
      au BufNewFile,BufRead *.tpl setlocal filetype=mustache
      au BufNewFile,BufRead *.{yaml,yml} if getline(1) =~ '^apiVersion:' || getline(2) =~ '^apiVersion:' | setlocal filetype=helm | endif

      " ========== Copilot Settings ==========
      let g:copilot_no_tab_map = v:true
      inoremap <silent><C-j> <Plug>(copilot-next)
      inoremap <silent><C-k> <Plug>(copilot-previous)
      inoremap <silent><C-\> <Plug>(copilot-dismiss)
      inoremap <silent><script><expr> <C-l> copilot#Accept("\<CR>")

      " ========== CoC Configuration ==========
      " Check for backspace
      function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      " Use <c-space> to trigger completion
      inoremap <silent><expr> <c-space> coc#refresh()

      " Navigate diagnostics
      nmap <silent> [c <Plug>(coc-diagnostic-prev)
      nmap <silent> ]c <Plug>(coc-diagnostic-next)

      " GoTo code navigation
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)
      nmap <silent> gb <C-o>
      nmap <silent> gn <C-i>

      " Use K to show documentation in preview window
      nnoremap <silent> K :call ShowDocumentation()<CR>

      function! ShowDocumentation()
        if CocAction('hasProvider', 'hover')
          call CocActionAsync('doHover')
        else
          call feedkeys('K', 'in')
        endif
      endfunction

      " Rename symbol
      nmap <leader>rn <Plug>(coc-rename)

      " Format selected code
      vmap <leader>f  <Plug>(coc-format-selected)
      nmap <leader>f  <Plug>(coc-format-selected)

      " Setup formatexpr for specific filetypes
      augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s)
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
      augroup end

      " Applying codeAction to the selected region
      xmap <leader>a  <Plug>(coc-codeaction-selected)
      nmap <leader>a  <Plug>(coc-codeaction-selected)

      " Apply codeAction to the current buffer
      nmap <leader>ac  <Plug>(coc-codeaction)

      " Apply AutoFix to problem on the current line
      nmap <leader>qf  <Plug>(coc-fix-current)

      " Run the Code Lens action on the current line
      nmap <leader>cl  <Plug>(coc-codelens-action)

      " Map function and class text objects
      xmap if <Plug>(coc-funcobj-i)
      omap if <Plug>(coc-funcobj-i)
      xmap af <Plug>(coc-funcobj-a)
      omap af <Plug>(coc-funcobj-a)
      xmap ic <Plug>(coc-classobj-i)
      omap ic <Plug>(coc-classobj-i)
      xmap ac <Plug>(coc-classobj-a)
      omap ac <Plug>(coc-classobj-a)

      " Remap <C-f> and <C-b> for scroll float windows/popups
      if has('nvim-0.4.0') || has('patch-8.2.0750')
        nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      endif

      " Use CTRL-S for selections ranges
      nmap <silent> <C-s> <Plug>(coc-range-select)
      xmap <silent> <C-s> <Plug>(coc-range-select)

      " CoC commands
      command! -nargs=0 Format :call CocActionAsync('format')
      command! -nargs=? Fold :call CocAction('fold', <f-args>)
      command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

      " CoC list mappings
      nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
      nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
      nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
      nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
      nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
      nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
      nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
      nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

      " Tab completion for CoC
      inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

      autocmd FileType go let b:coc_suggest_disable = 0
      autocmd FileType go let b:coc_snippet_disable = 0
      autocmd FileType go setlocal noexpandtab

      let g:go_code_completion_enabled = 0
      let g:go_gopls_enabled = 1
      let g:go_def_mapping_enabled = 0

      " Enter to confirm completion
      inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
      inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"
      inoremap <expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

      " CoC extensions
      let g:coc_global_extensions = [
        \ 'coc-json',
        \ 'coc-yaml',
        \ 'coc-lists',
        \ 'coc-snippets',
        \ 'coc-highlight',
        \ 'coc-pyright'
        \ ]

      " Jump to tag
      nn <M-g> :call JumpToDef()<cr>
      ino <M-g> <esc>:call JumpToDef()<cr>i

      " OPA/Rego formatting
      let g:formatdef_rego = '"opa fmt"'
      let g:formatters_rego = ['rego']
      let g:autoformat_autoindent = 0
      let g:autoformat_retab = 0
      au BufWritePre *.rego Autoformat
      let g:autoformat_verbosemode = 1

      " Terraform formatting
      autocmd BufWritePre *.hcl,*.tf call terraform#fmt()

      " UltiSnips author setting
      let g:snips_author = "burdz"

      " GitGutter summary function
      function! GitStatus()
        let [a,m,r] = GitGutterGetHunkSummary()
        return printf('+%d ~%d -%d', a, m, r)
      endfunction

      " vim-plug window configuration
      let g:plug_window = 'vertical topleft new'
      let g:plug_pwindow = 'above 12new'

      " Status line configuration
      set laststatus=2
      set statusline=
      set statusline+=%#PmenuSel#
      set statusline+=%{FugitiveStatusline()}
      set statusline+=%#LineNr#
      set statusline+=\ %f
      set statusline+=%m\
      set statusline+=%=
      set statusline+=%#StatusLine#
      set statusline+=%{GitStatus()}
      set statusline+=\ %y
      set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
      set statusline+=\[%{&fileformat}\]
      set statusline+=\ %p%%
      set statusline+=\ %l:%c

      " Syntax highlighting debug
      nmap <leader>sp :call <SID>SynStack()<CR>
      function! <SID>SynStack()
        if !exists("*synstack")
          return
        endif
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
      endfunc

      nmap ]h <Plug>(GitGutterNextHunk)
      nmap [h <Plug>(GitGutterPrevHunk)

      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l
    '';
  };

  # CoC configuration file
  home.file.".vim/coc-settings.json".text = ''
    {
      "coc.preferences.extensionUpdateCheck": "never",
      "coc.preferences.promptInput": false,
      "suggest.enablePreselect": false,
      "suggest.noselect": true,
      "highlight.colors.enable": false,
      "highlight.document.enable": false,
      "languageserver": {
        "golang": {
          "command": "gopls",
          "rootPatterns": ["go.mod", "Gopkg.toml"],
          "filetypes": ["go"],
          "initializationOptions": {
            "buildFlags": ["-tags=integration,infra,paasmutable,paasimmutable,promotion"]
          }
        },
        "dockerfile": {
          "command": "docker-langserver",
          "filetypes": ["dockerfile"],
          "args": ["--stdio"]
        },
        "bash": {
          "command": "bash-language-server",
          "args": ["start"],
          "filetypes": ["sh"],
          "ignoredRootPaths": ["~"]
        },
        "terraform": {
          "command": "terraform-ls",
          "filetypes": ["terraform"],
          "initializationOptions": {}
        },
        "rust": {
          "command": "rust-analyzer",
          "filetypes": ["rust"],
          "rootPatterns": ["Cargo.toml"]
        },
        "nix": {
          "command": "nil",
          "filetypes": ["nix"],
          "rootPatterns": ["flake.nix"],
          "settings": {
            "nil": {
              "formatting": { "command": ["nixfmt"] }
            }
          }
        },
        "zig": {
          "command": "zls",
          "filetypes": ["zig","zon"]
        }
      }
    }
  '';
}
