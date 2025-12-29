{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      comment-nvim
      copilot-vim
      dashboard-nvim
      editorconfig-vim
      fidget-nvim
      flash-nvim
      gitsigns-nvim
      indent-blankline-nvim
      lualine-nvim
      luasnip
      mini-nvim
      nvim-autopairs
      nvim-cmp
      nvim-lspconfig
      nvim-tree-lua
      nvim-treesitter-textobjects
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      plenary-nvim
      tabout-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      treesj
      tokyonight-nvim
      vim-eunuch
      vim-fugitive
      vim-rhubarb
      vim-visual-multi
      which-key-nvim
    ];

    extraPackages = with pkgs; [
      fd
      gofumpt
      gopls
      nil
      nodePackages.bash-language-server
      dockerfile-language-server
      nodePackages.typescript-language-server
      ripgrep
      rust-analyzer
      terraform-ls
      tree-sitter
      zls
    ];

    extraLuaConfig = ''
            vim.g.mapleader = ' '
            vim.g.maplocalleader = ' '

            require('tokyonight').setup({
              style = 'night',
              transparent = true,
              terminal_colors = true,
              styles = {
                sidebars = 'transparent',
                floats = 'transparent',
              },
            })

            vim.cmd.colorscheme('tokyonight')
            vim.cmd('set termguicolors')
            vim.cmd('hi StatusLine guibg=NONE ctermbg=NONE')
            vim.cmd('hi StatusLineNC guibg=NONE ctermbg=NONE')

            vim.g.have_nerd_font = true

            vim.opt.number = true
            vim.opt.relativenumber = false

            vim.opt.guicursor = 'n-v-c:ver25,i-ci-ve:ver25,r-cr-o:ver25'

            vim.opt.mouse = 'a'

            vim.opt.showmode = false

            vim.schedule(function()
              vim.opt.clipboard = 'unnamedplus'
            end)

            vim.opt.breakindent = true

            vim.opt.undofile = true
            vim.opt.undolevels = 10000
            vim.opt.history = 10000

            vim.opt.ignorecase = true
            vim.opt.smartcase = true

            vim.opt.signcolumn = 'yes'

            vim.opt.updatetime = 250
            vim.opt.timeoutlen = 300

            vim.opt.splitright = true
            vim.opt.splitbelow = true

            vim.opt.list = true
            vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

            vim.opt.inccommand = 'split'

            vim.opt.cursorline = true

            vim.opt.scrolloff = 10
            vim.opt.sidescrolloff = 5

            vim.opt.spell = true
            vim.opt.spelllang = 'en_au'

            vim.opt.encoding = 'utf-8'
            vim.opt.fileencoding = 'utf-8'

            vim.opt.hlsearch = true
            vim.opt.incsearch = true

            vim.opt.wrap = true
            vim.opt.showcmd = true
            vim.opt.laststatus = 2
            vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

            vim.opt.autoread = true
            vim.opt.autowrite = true
            vim.opt.autowriteall = true

            vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

            vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

            vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
            vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
            vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
            vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
            vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Left in insert mode" })
            vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Down in insert mode" })
            vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Up in insert mode" })
            vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Right in insert mode" })

            vim.api.nvim_create_user_command('E', 'e<bang>', { bang = true })
            vim.api.nvim_create_user_command('Q', 'q<bang>', { bang = true })
            vim.api.nvim_create_user_command('W', 'w<bang>', { bang = true })
            vim.api.nvim_create_user_command('QA', 'qa<bang>', { bang = true })
            vim.api.nvim_create_user_command('Qa', 'qa<bang>', { bang = true })
            vim.api.nvim_create_user_command('Wa', 'wa<bang>', { bang = true })
            vim.api.nvim_create_user_command('WA', 'wa<bang>', { bang = true })
            vim.api.nvim_create_user_command('Wq', 'wq<bang>', { bang = true })
            vim.api.nvim_create_user_command('WQ', 'wq<bang>', { bang = true })

            vim.keymap.set('v', '<C-c>', 'y', { desc = 'Copy to clipboard' })
            vim.api.nvim_create_autocmd('TextYankPost', {
              desc = 'Highlight when yanking (copying) text',
              group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
              callback = function()
                vim.highlight.on_yank()
              end,
            })

            vim.api.nvim_create_autocmd('FileType', {
              pattern = 'go',
              callback = function()
                vim.opt_local.expandtab = false
              end,
            })

            require('nvim-treesitter.configs').setup({
              highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
              },
              indent = {
                enable = true,
              },
            })

            local treesj = require('treesj')
            treesj.setup({})
            vim.keymap.set('n', '<space>m', treesj.toggle, { desc = 'Toggle Treesj split/join' })

            require('fidget').setup({})

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            vim.lsp.config('gopls', {
              cmd = { 'gopls' },
              filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
              root_markers = { 'go.work', 'go.mod', '.git' },
              capabilities = capabilities,
              settings = {
                gopls = {
                  buildFlags = { '-tags=integration,infra,paasmutable,paasimmutable,promotion' },
                  analyses = {
                    unusedparams = true,
                  },
                  gofumpt = true,
                  staticcheck = true,
                  usePlaceholders = true,
                },
              },
            })

            vim.lsp.config('rust_analyzer', {
              cmd = { 'rust-analyzer' },
              filetypes = { 'rust' },
              root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
              capabilities = capabilities,
            })

            vim.lsp.config('terraformls', {
              cmd = { 'terraform-ls', 'serve' },
              filetypes = { 'terraform', 'terraform-vars', 'hcl' },
              root_markers = { '.terraform', '.git' },
              capabilities = capabilities,
            })

            vim.lsp.config('bashls', {
              cmd = { 'bash-language-server', 'start' },
              filetypes = { 'sh', 'bash' },
              root_markers = { '.git' },
              capabilities = capabilities,
            })

            vim.lsp.config('dockerls', {
              cmd = { 'docker-langserver', '--stdio' },
              filetypes = { 'dockerfile' },
              root_markers = { 'Dockerfile', '.git' },
              capabilities = capabilities,
            })

            vim.lsp.config('nil_ls', {
              cmd = { 'nil' },
              filetypes = { 'nix' },
              root_markers = { 'flake.nix', '.git' },
              capabilities = capabilities,
              settings = {
                ['nil'] = {
                  formatting = {
                    command = { 'nixfmt' },
                  },
                },
              },
            })

            vim.lsp.config('zls', {
              cmd = { 'zls' },
              filetypes = { 'zig', 'zon' },
              root_markers = { 'build.zig', 'zls.json', '.git' },
              capabilities = capabilities,
            })

            vim.lsp.config('ts_ls', {
              cmd = { 'typescript-language-server', '--stdio' },
              filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
              root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
              capabilities = capabilities,
            })

            vim.lsp.enable('gopls')
            vim.lsp.enable('rust_analyzer')
            vim.lsp.enable('terraformls')
            vim.lsp.enable('bashls')
            vim.lsp.enable('dockerls')
            vim.lsp.enable('nil_ls')
            vim.lsp.enable('zls')
            vim.lsp.enable('ts_ls')

            vim.api.nvim_create_autocmd('LspAttach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
              callback = function(event)
                local map = function(keys, func, desc)
                  vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
                map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
                map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
                map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                map('K', vim.lsp.buf.hover, 'Hover Documentation')
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                map('gb', '<C-o>', '[G]o [B]ack')

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.server_capabilities.documentHighlightProvider then
                  local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.document_highlight,
                  })

                  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.clear_references,
                  })

                  vim.api.nvim_create_autocmd('LspDetach', {
                    group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                    callback = function(event2)
                      vim.lsp.buf.clear_references()
                      vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
                    end,
                  })
                end

                if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                  map('<leader>th', function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                  end, '[T]oggle Inlay [H]ints')
                end
              end,
            })

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.handlers.signature_help

            vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = '[F]ormat buffer' })
            vim.keymap.set('v', '<leader>f', vim.lsp.buf.format, { desc = '[F]ormat selection' })

            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = '*.go',
                callback = function()
                  local params = vim.lsp.util.make_range_params()
                  params.context = {only = {"source.organizeImports"}}

                  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)

                  for cid, res in pairs(result or {}) do
                    for _, r in pairs(res.result or {}) do
                      if r.edit then
                        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                        vim.lsp.util.apply_workspace_edit(r.edit, enc)
                      end
                    end
                  end

                  vim.lsp.buf.format({ async = false })
                end,
            })

            vim.api.nvim_create_autocmd('BufWritePre',{
              pattern = {"*.zig", "*.zon"},
              callback = function(ev)
                vim.lsp.buf.format()
              end
      }     )

            local cmp = require('cmp')
            local luasnip = require('luasnip')

            cmp.setup({
              snippet = {
                expand = function(args)
                  luasnip.lsp_expand(args.body)
                end,
              },
              completion = { completeopt = 'menu,menuone,noinsert' },
              mapping = cmp.mapping.preset.insert({
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),

                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),

                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),

                ['<C-Space>'] = cmp.mapping.complete({}),

                ['<Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                  else
                    fallback()
                  end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
                end, { 'i', 's' }),
              }),
              sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'path' },
              }, {
                { name = 'buffer' },
              }),
            })

            local telescope = require('telescope')
            local builtin = require('telescope.builtin')

            telescope.setup({
              defaults = {
                file_ignore_patterns = { '.git/', 'node_modules', '*.swp' },
                mappings = {
                  i = {
                    ['<C-u>'] = false,
                    ['<C-d>'] = false,
                  },
                },
              },
            })

            pcall(telescope.load_extension, 'fzf')

            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

            vim.keymap.set('n', '<leader>/', function()
              builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
                winblend = 10,
                previewer = false,
              }))
            end, { desc = '[/] Fuzzily search in current buffer' })

            vim.keymap.set('n', '<leader>s/', function()
              builtin.live_grep({
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
              })
            end, { desc = '[S]earch [/] in Open Files' })

            vim.keymap.set('n', '<leader>sn', function()
              builtin.find_files({ cwd = vim.fn.stdpath('config') })
            end, { desc = '[S]earch [N]eovim files' })

            vim.keymap.set('n', ';f', builtin.find_files, { desc = 'Find files' })
            vim.keymap.set('n', ';w', builtin.live_grep, { desc = 'Live grep' })
            vim.keymap.set('n', ';b', builtin.buffers, { desc = 'Buffers' })
            vim.keymap.set('n', ';c', builtin.git_commits, { desc = 'Git commits' })
            vim.keymap.set('n', ';h', builtin.command_history, { desc = 'Command history' })
            vim.keymap.set('n', ';m', builtin.keymaps, { desc = 'Keymaps' })
            vim.keymap.set('n', ';j', builtin.tags, { desc = 'Tags' })

            require('nvim-tree').setup({
              view = {
                side = 'left',
                width = 30,
              },
              filters = {
                dotfiles = false,
              },
            })

            vim.keymap.set('n', '<F6>', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
            vim.keymap.set('n', '<C-p>', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree' })

            local close_tree_group = vim.api.nvim_create_augroup('close-nvim-tree-when-alone', { clear = true })
            local has_seen_non_tree_buffer = false

            vim.api.nvim_create_autocmd('BufEnter', {
              group = close_tree_group,
              nested = true,
              callback = function()
                local is_tree = vim.bo.filetype == 'NvimTree'

                if not is_tree then
                  has_seen_non_tree_buffer = true
                  return
                end

                if has_seen_non_tree_buffer and #vim.api.nvim_list_wins() == 1 then
                  vim.cmd('quit')
                end
              end,
            })

            require('gitsigns').setup({
              signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
              },
              on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                vim.keymap.set('n', ']h', gs.next_hunk, { buffer = bufnr, desc = 'Next hunk' })
                vim.keymap.set('n', '[h', gs.prev_hunk, { buffer = bufnr, desc = 'Previous hunk' })
              end,
            })

            require('lualine').setup({
              options = {
                icons_enabled = true,
                theme = 'tokyonight',
                component_separators = { left = '|', right = '|'},
                section_separators = { left = '/', right = '/'},
                disabled_filetypes = {
                  statusline = {},
                  winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                  statusline = 1000,
                  tabline = 1000,
                  winbar = 1000,
                }
              },
              sections = {
                lualine_a = {'mode'},
                lualine_b = {
                  'branch',
                  'diff',
                  {
                    'diagnostics',
                    sources = { 'nvim_lsp' },
                    symbols = { error = 'E:', warn = 'W:', info = 'I:', hint = 'H:' },
                  }
                },
                lualine_c = {
                  {
                    'filename',
                    file_status = true,
                    path = 1,
                  }
                },
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
              },
              inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
              },
              tabline = {},
              winbar = {},
              inactive_winbar = {},
              extensions = {'nvim-tree', 'fugitive'}
            })

            require('dashboard').setup({
              theme = 'hyper',
              config = {
                header = {
                  '_                  _',
                  '| |                | |',
                  '     | |__  _  _ _ __ __| |_____',
                  '     | \'_ \\| | | | \'__/ _` |_  /',
                  '     | |_) | |_| | | | (_| |/ /',
                  '     |_.__/ \\__,_|_|  \\__,_/___|',
                },
                week_header = { enable = false },
                packages = { enable = false },
                footer = { ':(){ :|:& };:' },
                shortcut = {
                  {
                    icon = ' ',
                    icon_hl = '@variable',
                    desc = 'Files',
                    group = 'Label',
                    action = 'Telescope find_files',
                    key = 'f',
                  },
                },
              },
            })

            vim.api.nvim_create_autocmd('FileType', {
              pattern = 'qf',
              callback = function()
                vim.keymap.set('n', '<CR>', '<CR>:cclose<CR>', { buffer = true })
              end,
            })

            vim.api.nvim_create_autocmd('FileType', {
              pattern = { 'help', 'lspinfo', 'man', 'checkhealth' },
              callback = function(event)
                vim.bo[event.buf].buflisted = false
                vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
              end,
            })

            require('nvim-autopairs').setup({
              check_ts = true,
              ts_config = {
                lua = { 'string' },
                javascript = { 'template_string' },
              },
            })

            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

            require('which-key').setup({
              plugins = {
                spelling = {
                  enabled = true,
                  suggestions = 20,
                },
              },
            })

            require('ibl').setup({
              indent = {
                char = '│',
              },
              scope = {
                enabled = true,
                show_start = false,
                show_end = false,
              },
              exclude = {
                filetypes = { 'dashboard' },
              },
            })

            require('flash').setup({
              labels = "asdfghjklqwertyuiopzxcvbnm",
              search = {
                multi_window = true,
                forward = true,
                wrap = true,
              },
              jump = {
                jumplist = true,
                pos = "start",
                history = false,
                register = false,
                nohlsearch = false,
              },
              label = {
                uppercase = true,
                rainbow = {
                  enabled = false,
                  shade = 5,
                },
              },
              modes = {
                search = {
                  enabled = true,
                },
                char = {
                  enabled = true,
                  jump_labels = true,
                },
              },
            })

            vim.keymap.set({ 'n', 'x', 'o' }, 'zk', function() require('flash').jump() end, { desc = 'Flash jump' })
            vim.keymap.set({ 'n', 'x', 'o' }, 'Zk', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })
            vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })
            vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, { desc = 'Treesitter Search' })
            vim.keymap.set('c', '<c-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' })

            require('nvim-treesitter.configs').setup({
              textobjects = {
                select = {
                  enable = true,
                  lookahead = true,
                  keymaps = {
                    -- capture groups defined in textobjects.scm
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner',
                    ['aa'] = '@parameter.outer',
                    ['ia'] = '@parameter.inner',
                    ['ab'] = '@block.outer',
                    ['ib'] = '@block.inner',
                    ['al'] = '@loop.outer',
                    ['il'] = '@loop.inner',
                    ['ai'] = '@conditional.outer',
                    ['ii'] = '@conditional.inner',
                  },
                },
                move = {
                  enable = true,
                  set_jumps = true,
                  goto_next_start = {
                    [']f'] = '@function.outer',
                    [']c'] = '@class.outer',
                    [']a'] = '@parameter.inner',
                  },
                  goto_next_end = {
                    [']F'] = '@function.outer',
                    [']C'] = '@class.outer',
                    [']A'] = '@parameter.inner',
                  },
                  goto_previous_start = {
                    ['[f'] = '@function.outer',
                    ['[c'] = '@class.outer',
                    ['[a'] = '@parameter.inner',
                  },
                  goto_previous_end = {
                    ['[F'] = '@function.outer',
                    ['[C'] = '@class.outer',
                    ['[A'] = '@parameter.inner',
                  },
                },
                swap = {
                  enable = true,
                  swap_next = {
                    ['<leader>a'] = '@parameter.inner',
                  },
                  swap_previous = {
                    ['<leader>A'] = '@parameter.inner',
                  },
                },
              },
            })

            require('tabout').setup({
              tabkey = '<Tab>',
              backwards_tabkey = '<S-Tab>',
              act_as_tab = true,
              act_as_shift_tab = false,
              default_tab = '<C-t>',
              default_shift_tab = '<C-d>',
              enable_backwards = true,
              completion = true,
              tabouts = {
                { open = "'", close = "'" },
                { open = '"', close = '"' },
                { open = '`', close = '`' },
                { open = '(', close = ')' },
                { open = '[', close = ']' },
                { open = '{', close = '}' },
              },
              ignore_beginning = true,
              exclude = {},
            })

            require('mini.surround').setup({
              mappings = {
                add = 'gsa',
                delete = 'gsd',
                find = 'gsf',
                find_left = 'gsF',
                highlight = 'gsh',
                replace = 'gsr',
                update_n_lines = 'gsn',
                suffix_last = 'l',
                suffix_next = 'n',
              },
            })

            vim.diagnostic.config({
              float = {
                source = 'always',
                border = border
              },
            })

            vim.g.VM_maps = {
              ['Find Under'] = '<C-n>',
              ['Find Subword Under'] = '<C-n>',
              ['Select All'] = '<C-n>',
              ['Skip Region'] = '<C-x>',
              ['Remove Region'] = '<C-p>',
            }

            vim.keymap.set('n', '<C-d>', '<C-d>zz')
            vim.keymap.set('n', '<C-b>', '<C-b>zz')

            vim.g.copilot_no_tab_map = true
            vim.keymap.set('i', '<C-j>', 'copilot#Next()', { expr = true, silent = true })
            vim.keymap.set('i', '<C-k>', 'copilot#Previous()', { expr = true, silent = true })
            vim.keymap.set('i', '<C-\\>', 'copilot#Dismiss()', { expr = true, silent = true })
            vim.keymap.set('i', '<C-l>', 'copilot#Accept("\\<CR>")', { expr = true, silent = true, replace_keycodes = false })
    '';
  };
}
