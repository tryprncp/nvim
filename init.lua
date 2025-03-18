vim.g.mapleader = ' ' vim.g.maplocalleader = ' ' vim.g.have_nerd_font = true vim.g.COLORSCHEME = 'habamax' vim.g.HIGHLIGHT = true vim.g.LSP_ENABLE = true vim.g.AUTOCOMPLETE = true vim.g.TSCONTEXT = true if vim.g.neovide then vim.o.guifont = 'JetBrainsMono Nerd Font Mono:h10' vim.g.neovide_padding_top = 10 vim.g.neovide_padding_bottom = 10 vim.g.neovide_padding_left = 10 vim.g.neovide_padding_right = 10 vim.g.neovide_cursor_vfx_mode = 'pixiedust' vim.g.neovide_cursor_vfx_particle_lifetime = 1.5 vim.g.neovide_cursor_vfx_particle_density = 8.0 end vim.opt.tabstop = 4 vim.opt.expandtab = true vim.opt.laststatus = 3 vim.opt.breakindent = true vim.opt.autoindent = true vim.opt.smartindent = true vim.opt.foldcolumn = 'auto' vim.opt.wrap = false vim.opt.mouse = '' vim.opt.number = false vim.opt.relativenumber = true vim.opt.showmode = false vim.opt.undofile = true vim.opt.ignorecase = true vim.opt.smartcase = true vim.opt.hlsearch = true vim.opt.incsearch = true vim.opt.updatetime = 250 vim.opt.timeoutlen = 300 vim.opt.splitright = true vim.opt.splitbelow = true vim.opt.cursorline = true vim.opt.scrolloff = 10 vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>') vim.keymap.set('o', '_', '^') vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<cr>', { desc = 'Make this file executable', silent = true }) vim.keymap.set('n', '<C-c>', '<cmd>nohlsearch<cr>') vim.keymap.set('i', '<C-c>', '<Esc>') vim.keymap.set('n', 'Q', '<nop>') vim.keymap.set('n', 'J', 'mzJ`z') vim.keymap.set('n', '<leader>tn', '<cmd>set invrelativenumber | set invnumber<cr>', { desc = 'Toggle relative line number' }) vim.keymap.set('n', '<leader>tw', '<cmd>set invwrap<cr>', { desc = 'Toggle line wrap' }) vim.keymap.set('n', 'gh', '<cmd>diffget //2<cr>', { desc = 'Get the hunk in the left' }) vim.keymap.set('n', 'gl', '<cmd>diffget //3<cr>', { desc = 'Get the hunk in the right' }) vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv") vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv") vim.keymap.set('v', '<', '<gv') vim.keymap.set('v', '>', '>gv') vim.keymap.set('n', '<leader>k', '<cmd>cprev<cr>zz', { desc = 'Previous item in qfixlist' }) vim.keymap.set('n', '<leader>j', '<cmd>cnext<cr>zz', { desc = 'Next item in qfixlist' }) vim.keymap.set('n', 'n', 'nzzzv') vim.keymap.set('n', 'N', 'Nzzzv') vim.keymap.set('x', '<leader>p', '"_dP') vim.keymap.set('v', '<leader>y', '"+y') vim.keymap.set('n', '<leader>Y', '"+Y') vim.keymap.set('v', '<leader>d', '"_d') vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev { float = { border = 'rounded' } } end, { desc = 'Previous diagnostics message' }) vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next { float = { border = 'rounded' } } end, { desc = 'Next diagnostics message' }) vim.keymap.set('n', '<leader>d', function() vim.diagnostic.open_float { border = 'rounded' } end, { desc = 'Show diagnostics message' }) vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' }) vim.api.nvim_create_autocmd('TextYankPost', { desc = 'Highlight when yoinking', callback = function() vim.highlight.on_yank() end }) vim.api.nvim_create_autocmd('VimEnter', { desc = 'Restore colorscheme', nested = true, callback = function() pcall(vim.cmd.colorscheme, vim.g.COLORSCHEME) end }) vim.api.nvim_create_autocmd('ColorScheme', { desc = 'Customize highlight groups', callback = function(params) vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { link = 'Title' }) vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = 'NONE' }) vim.api.nvim_set_hl(0, 'WinSeparator', { link = 'LineNr' }) vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#1c1d27' }) if not vim.g.neovide then vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' }) vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' }) end vim.g.COLORSCHEME = params.match end }) vim.api.nvim_create_autocmd('LspAttach', { desc = 'Restore LSP functionality', callback = function() if vim.g.LSP_ENABLE then vim.cmd('LspStart') else vim.cmd( 'LspStop') end end }) vim.api.nvim_create_autocmd('CmdlineLeave', { desc = 'Toggle the global variables', callback = function() local cmdline = vim.fn.getcmdline() if cmdline:match('^LspStop') then vim.g.LSP_ENABLE = false elseif cmdline:match('^LspStart') then vim.g.LSP_ENABLE = true elseif cmdline:match('^TSToggle highlight') then vim.g.HIGHLIGHT = not vim.g.HIGHLIGHT elseif cmdline:match('^TSContextToggle') then vim.g.TSCONTEXT = not vim.g.TSCONTEXT end end }) local ns = vim.api.nvim_create_namespace('TrailingWhitespace') vim.api.nvim_create_autocmd({ 'BufWinEnter', 'TextChanged', 'InsertLeave' }, { desc = 'Hint on trailing whitespace', callback = function() local bufnr = vim.api.nvim_get_current_buf() if not vim.bo[bufnr].modifiable or vim.bo[bufnr].buftype ~= '' then vim.diagnostic.reset(ns, bufnr) return end local diagnostics = {} for lnum = 0, vim.api.nvim_buf_line_count(bufnr) - 1 do local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1] if line and line:match('%s+$') then diagnostics[#diagnostics + 1] = { lnum = lnum, col = #line:match('^(.-)%s*$'), end_col = # line, severity = vim.diagnostic.severity.HINT, message = line:match('^%s*$') and 'Line with spaces only.' or 'Line with trailing space.', source = 'custom-lint' } end end vim.diagnostic.set(ns, bufnr, diagnostics) end }) vim.filetype.add({ pattern = { ['.*%.blade%.php'] = 'html' } }) local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim' if not vim.uv.fs_stat(lazypath) then local lazyrepo = 'https://github.com/folke/lazy.nvim.git' local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath } if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end end vim.opt.rtp:prepend(lazypath) require('lazy').setup { ui = { border = 'rounded' }, spec = { { 'neovim/nvim-lspconfig', event = 'VeryLazy', dependencies = { { 'williamboman/mason.nvim', opts = { ui = { border = 'rounded' } } }, 'williamboman/mason-lspconfig.nvim', 'WhoIsSethDaniel/mason-tool-installer.nvim' }, config = function() vim.api.nvim_create_autocmd('LspAttach', { group = vim.api.nvim_create_augroup('neovim-lsp-attach', { clear = true }), callback = function(event) local set = function(keys, func, desc) vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }) end vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded', max_width = 90 }) local default_handler = vim.lsp.handlers['textDocument/publishDiagnostics'] vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config) if result and result.diagnostics then result.diagnostics = vim.tbl_filter( function(diag) return not diag.message:match('[Tt]railing%s+[Ss]pace') and not diag.message:match('spaces%s+only') end, result.diagnostics) end return default_handler(err, result, ctx, config) end set('gd', require('telescope.builtin').lsp_definitions, 'Go to definition') set('gr', require('telescope.builtin').lsp_references, 'Goto references') set('gI', require('telescope.builtin').lsp_implementations, 'Goto implementation') set('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type definition') set('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document symbols') set('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace symbols') set('<leader>rn', vim.lsp.buf.rename, 'Rename') set('<leader>ca', vim.lsp.buf.code_action, 'Code action') set('K', vim.lsp.buf.hover, 'Hover documentation') set('gD', vim.lsp.buf.declaration, 'Go to declaration') local client = vim.lsp.get_client_by_id(event.data.client_id) if client and client.server_capabilities.documentHighlightProvider then local highlight_augroup = vim.api.nvim_create_augroup('neovim-lsp-highlight', { clear = false }) vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { buffer = event.buf, group = highlight_augroup, callback = vim.lsp.buf.document_highlight }) vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { buffer = event.buf, group = highlight_augroup, callback = vim.lsp.buf.clear_references }) vim.api.nvim_create_autocmd('LspDetach', { group = vim.api.nvim_create_augroup('neovim-lsp-detach', { clear = true }), callback = function(event2) vim.lsp.buf.clear_references() vim.api.nvim_clear_autocmds { group = 'neovim-lsp-highlight', buffer = event2.buf } end }) end if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then set('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, 'Toggle inlay hints') end end }) local capabilities = vim.lsp.protocol.make_client_capabilities() capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities()) local servers = { bashls = { settings = { bashIde = { shfmt = { caseIndent = true, spaceRedirects = true } } } }, html = { settings = { html = { format = { indentInnerHtml = true, wrapLineLength = 0 } } } }, lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' }, diagnostics = { disable = { 'missing-fields' } }, format = { enable = true, defaultConfig = { trailing_table_separator = 'smart', quote_style = 'single' } } } } } } local ensure_installed = vim.tbl_keys(servers or {}) vim.list_extend(ensure_installed, { 'clang-format', 'phpcbf', 'shfmt' }) require('mason-tool-installer').setup { ensure_installed = ensure_installed } require('mason-lspconfig').setup { handlers = { function(server_name) local server = servers[server_name] or {} server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {}) require('lspconfig')[server_name].setup(server) end } } if not next(vim.lsp.get_clients({ bufnr = 0 })) then pcall(function() vim.cmd.edit() end) end end }, { 'windwp/nvim-ts-autotag', event = 'InsertEnter', opts = { aliases = { ['php'] = 'html' } } }, { 'stevearc/conform.nvim', keys = { { '<leader>f', function() if vim.bo.modifiable and vim.bo.buftype == '' then require('conform').format { async = true, lsp_fallback = true } else vim.notify( 'Error: no formatter attached to current buffer', vim.log.levels.ERROR) end end, desc = 'Format buffer' } }, opts = { formatters_by_ft = { c = { 'clang_format' }, php = { 'phpcbf' } }, formatters = { clang_format = { args = { '--style={BasedOnStyle: Google, IndentWidth: 4, UseTab: Never}' } }, phpcbf = { prepend_args = { '--standard=PSR12' } } } } }, { 'hrsh7th/nvim-cmp', event = 'VeryLazy', dependencies = { { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' }, 'saadparwaiz1/cmp_luasnip', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline' }, opts = function() vim.keymap.set('n', '<leader>ta', function() vim.g.AUTOCOMPLETE = not vim.g.AUTOCOMPLETE require('cmp').setup({ completion = { autocomplete = vim.g.AUTOCOMPLETE and { 'InsertEnter', 'TextChanged' } } }) end, { noremap = true, silent = true, desc = 'Toggle autocompletion' }) local cmp = require('cmp') local luasnip = require('luasnip') local devicons = { Text = '', Method = '󰆧', Function = '󰊕', Constructor = '', Field = '󰇽', Variable = '󰂡', Class = '󰠱', Interface = '', Module = '', Property = '󰜢', Unit = '', Value = '󰎠', Enum = '', Keyword = '󰌋', Snippet = '', Color = '󰏘', File = '󰈙', Reference = '', Folder = '󰉋', EnumMember = '', Constant = '󰏿', Struct = '', Event = '', Operator = '󰆕', TypeParameter = '󰅲' } luasnip.config.setup {} cmp.setup { performance = { max_view_entries = 10 }, formatting = { format = function(_, vim_item) vim_item.kind = string.format('%s %s', devicons[vim_item.kind], vim_item.kind) return vim_item end }, window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() }, snippet = { expand = function( args) luasnip.lsp_expand(args.body) end }, completion = { autocomplete = vim.g.AUTOCOMPLETE and { 'InsertEnter', 'TextChanged' }, completeopt = 'menu,menuone,noinsert' }, mapping = cmp.mapping.preset.insert { ['<C-n>'] = cmp.mapping.select_next_item(), ['<C-p>'] = cmp.mapping.select_prev_item(), ['<C-b>'] = cmp.mapping.scroll_docs(-4), ['<C-f>'] = cmp.mapping.scroll_docs(4), ['<C-y>'] = cmp.mapping.confirm { select = true }, ['<C-Space>'] = cmp.mapping.complete(), ['<C-l>'] = cmp.mapping(function() if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end end, { 'i', 's' }), ['<C-h>'] = cmp.mapping(function() if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end end, { 'i', 's' }), ['<C-k>'] = function() if cmp.visible_docs() then cmp.close_docs() else cmp.open_docs() end end }, view = { docs = { auto_open = false } }, sources = { { name = 'lazydev', group_index = 0 }, { name = 'nvim_lsp' }, { name = 'luasnip' }, { name = 'path' }, { name = 'buffer', option = { get_bufnrs = function() return vim.tbl_filter(function(bufnr) return vim.bo[bufnr].buftype == '' end, vim.api.nvim_list_bufs()) end } } } } cmp.setup.cmdline({ '/', '?' }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } }) cmp.setup.cmdline(':', { mapping = cmp.mapping.preset.cmdline(), sources = cmp.config.sources({ { name = 'path' }, { name = 'cmdline' } }), matching = { disallow_symbol_nonprefix_matching = false } }) end }, { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', event = 'UIEnter', opts = function() require('nvim-treesitter.configs').setup({ ensure_installed = { 'bash', 'c', 'diff', 'html', 'css', 'javascript', 'python', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' }, auto_install = true, highlight = { enable = vim.g.HIGHLIGHT }, indent = { enable = true } }) vim.api.nvim_create_autocmd({ 'BufReadPost', 'ModeChanged' }, { desc = 'Disable treesitter on large files', callback = function() if vim.api.nvim_buf_line_count(0) > 10000 and vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then vim.cmd('TSDisable highlight') vim.cmd('TSDisable indent') elseif vim.g.HIGHLIGHT and not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then vim.cmd('TSEnable highlight') vim.cmd('TSEnable indent') end end }) end }, { 'nvim-treesitter/nvim-treesitter-context', event = 'WinScrolled', opts = function() require( 'treesitter-context').setup({ enable = vim.g.TSCONTEXT, multiwindow = true, max_lines = 5 }) end }, { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = { map_cr = true } }, { 'folke/lazydev.nvim', ft = 'lua', opts = { library = { { path = 'luvit-meta/library', words = { 'vim%.uv' } } } } }, { 'Bilal2453/luvit-meta', lazy = true }, { 'mbbill/undotree', keys = { { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'Toggle undotree' } } }, { 'folke/which-key.nvim', event = 'VeryLazy', opts = function() require('which-key').add { { '<leader>c', group = 'Code' }, { '<leader>r', group = 'Rename' }, { '<leader>s', group = 'Search' }, { '<leader>w', group = 'Workspace' }, { '<leader>t', group = 'Toggle' }, { '<leader>g', group = 'Git operations', mode = { 'n', 'v' } } } return { preset = 'modern' } end }, { 'echasnovski/mini.nvim', event = 'UIEnter', config = function() vim.api.nvim_create_autocmd('FileType', { pattern = { 'dashboard', 'fzf', 'help', 'lazy', 'mason', 'oil_preview' }, callback = function() vim.b.miniindentscope_disable = true end }) vim.keymap.set('n', '<leader>z', function() require('mini.misc').zoom() end, { desc = 'Toggle window zoom' }) require('mini.ai').setup { n_lines = 500 } require('mini.surround').setup() local icons = require('mini.icons') icons.setup() icons.mock_nvim_web_devicons() local hipatterns = require('mini.hipatterns') hipatterns.setup { highlighters = { fixme = { pattern = { ' FIXME ', 'FIXME', ' ERROR ', 'ERROR' }, group = 'MiniHipatternsFixme' }, hack = { pattern = { ' HACK ', 'HACK', ' WARN ', 'WARN' }, group = 'MiniHipatternsHack' }, todo = { pattern = { ' TODO ', 'TODO', ' NOTE ', 'NOTE' }, group = 'MiniHipatternsTodo' }, hex_color = hipatterns.gen_highlighter.hex_color() } } local statusline = require('mini.statusline') statusline.setup { content = { active = function() local mode, mode_hl = statusline.section_mode({ trunc_width = 120 }) local git = statusline.section_git({ trunc_width = 40 }) local diff = statusline.section_diff({ trunc_width = 75 }) local diagnostics = statusline.section_diagnostics({ trunc_width = 75 }) local filename = statusline.section_filename({ trunc_width = 140 }) local fileinfo = statusline.section_fileinfo({ trunc_width = 120 }) local location = '%2l:%-2v' local search = statusline.section_searchcount({ trunc_width = 75 }) return statusline.combine_groups({ { hl = mode_hl, strings = { mode } }, { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } }, '%<', { hl = 'MiniStatuslineFilename', strings = { filename } }, '%=', { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } }, { hl = mode_hl, strings = { search, location } } }) end } } local indentscope = require('mini.indentscope') indentscope.setup({ symbol = '│', options = { indent_at_cursor = false, try_as_border = true } }) end }, { 'christoomey/vim-tmux-navigator', keys = { { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' }, { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' }, { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' }, { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' } } }, { 'nvim-telescope/telescope.nvim', event = 'VeryLazy', dependencies = { 'nvim-lua/plenary.nvim', { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = function() return vim.fn.executable 'make' == 1 end }, { 'nvim-telescope/telescope-ui-select.nvim' } }, opts = function() local telescope = require('telescope') local builtin = require('telescope.builtin') local pickers = require('telescope.pickers') local previewers = require('telescope.previewers') local finders = require('telescope.finders') local conf = require('telescope.config').values local actions = require('telescope.actions') local action_state = require('telescope.actions.state') local set = vim.keymap.set telescope.setup { extensions = { fzf = {}, ['ui-select'] = { require('telescope.themes').get_dropdown() } } } pcall(require('telescope').load_extension, 'fzf') pcall(require('telescope').load_extension, 'ui-select') set('n', '<leader>sp', function() local search_dirs = { '~/', '~/projects', '~/practice', '~/programming', '~/php', '~/.local' } for i, dir in ipairs(search_dirs) do search_dirs[i] = vim.fn.expand(dir) end local search_cmd = vim.fn.executable('fd') == 1 and ('fd --type d --max-depth 2 --hidden --exclude .git ' .. table.concat(search_dirs, ' ')) or ('find ' .. table.concat(search_dirs, ' ') .. ' -mindepth 1 -maxdepth 2 -type d') local handle = io.popen(search_cmd) local results = {} if handle then for dir in handle:lines() do table.insert(results, dir) end handle:close() end pickers.new({}, { prompt_title = 'Search Projects', finder = finders.new_table({ results = results }), sorter = conf .generic_sorter({}), previewer = previewers.new_termopen_previewer({ title = 'Directory Contents', get_command = function( entry) local dir = entry.value if vim.fn.executable('eza') == 1 then return { 'eza', '-1', '--icons=always', '--group-directories-first', '--color=always', dir } else return { 'ls', '-1', '--color=always', dir } end end }), attach_mappings = function(_, map) map('i', '<CR>', function(bufnr) local dir = action_state.get_selected_entry()[1] actions.close(bufnr) vim.cmd('cd ' .. vim.fn.fnameescape(dir)) print('Changed directory to: ' .. dir) end) return true end }):find() end, { desc = 'Search Projects' }) set('n', '<leader>sc', function() if not pcall(function() builtin.git_commits() end) then vim.notify('Not in a Git repository', vim.log.levels.ERROR) end end, { desc = 'Search git commits' }) set('n', '<leader>sh', builtin.help_tags, { desc = 'Search help' }) set('n', '<leader>sk', builtin.keymaps, { desc = 'Search keymaps' }) set('n', '<leader>sf', builtin.find_files, { desc = 'Search files' }) set('n', '<leader>st', builtin.builtin, { desc = 'Search telescope' }) set('n', '<leader>sg', builtin.live_grep, { desc = 'Search by grep' }) set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search diagnostics' }) set('n', '<leader>sr', builtin.resume, { desc = 'Search resume' }) set('n', '<leader>s.', builtin.oldfiles, { desc = 'Search recent files ("." for repeat)' }) set('n', '<leader><leader>', builtin.buffers, { desc = 'Search existing buffers' }) set('n', '<leader>/', function() builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { previewer = false }) end, { desc = 'Fuzzy search current buffer' }) set('n', '<leader>s/', function() builtin.live_grep { grep_open_files = true } end, { desc = 'Search in open files' }) set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = 'Search neovim files' }) end }, { 'stevearc/oil.nvim', event = 'VimEnter', keys = { { '-', '<cmd>Oil<cr>', desc = 'Open file explorer' } }, opts = { delete_to_trash = true, default_file_explorer = true, skip_confirm_for_simple_edits = true, keymaps = { ['<C-h>'] = false, ['<C-l>'] = false, ['<M-h>'] = false } } }, { 'tpope/vim-fugitive', cmd = 'Git', keys = { { '<leader>gs', function() for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'fugitive' then return vim.api.nvim_win_close(win, true), vim.cmd('wincmd p') end end if not pcall(function() vim.cmd('Git') end) then vim.notify( 'fugitive: working directory does not belong to a Git repository', vim.log.levels.ERROR) end end, desc = 'Toggle Git window' } } }, { 'lewis6991/gitsigns.nvim', event = 'VeryLazy', opts = { signs = { add = { text = '+' }, change = { text = '~' }, delete = { text = '_' }, topdelete = { text = '‾' }, changedelete = { text = '~' } }, on_attach = function( bufnr) local gitsigns = require('gitsigns') local function set(mode, l, r, opts) opts = opts or {} opts.buffer = bufnr vim.keymap.set(mode, l, r, opts) end local function reload_fugitive_index() for _, buf in ipairs(vim.api.nvim_list_bufs()) do if vim.bo[buf].filetype == 'fugitive' then vim.api.nvim_buf_call(buf, function() vim.cmd.edit() end) end end end set('o', 'ih', '<cmd>Gitsigns select_hunk<cr>', { silent = true }) set('x', 'ih', ':Gitsigns select_hunk<cr>', { silent = true }) set('v', '<leader>ga', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } reload_fugitive_index() end, { desc = 'Stage hunk' }) set('v', '<leader>gr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } reload_fugitive_index() end, { desc = 'Reset hunk' }) set('n', ']h', function() gitsigns.nav_hunk('next') end, { desc = 'Next hunk' }) set('n', '[h', function() gitsigns.nav_hunk('prev') end, { desc = 'Previous hunk' }) set('n', '<leader>ga', function() gitsigns.stage_hunk() reload_fugitive_index() end, { desc = 'Stage hunk' }) set('n', '<leader>gA', function() gitsigns.stage_buffer() reload_fugitive_index() end, { desc = 'Stage all hunks' }) set('n', '<leader>gu', function() gitsigns.stage_hunk() reload_fugitive_index() end, { desc = 'Undo staged hunk' }) set('n', '<leader>gU', function() gitsigns.reset_buffer_index() reload_fugitive_index() end, { desc = 'Undo all staged hunks' }) set('n', '<leader>gr', function() gitsigns.reset_hunk() reload_fugitive_index() end, { desc = 'Reset hunk' }) set('n', '<leader>gR', function() gitsigns.reset_buffer() reload_fugitive_index() end, { desc = 'Reset all hunks' }) set('n', '<leader>gD', function() gitsigns.diffthis('@') end, { desc = 'Diff against last commit' }) set('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview hunk' }) set('n', '<leader>gb', gitsigns.blame_line, { desc = 'Blame line' }) set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle line blame' }) set('n', '<leader>td', gitsigns.preview_hunk_inline, { desc = 'Toggle deleted/changed hunks' }) set('n', '<leader>gd', function() if vim.wo.diff then vim.cmd('diffoff!') vim.cmd('wincmd p') vim.cmd('q') vim.cmd('wincmd p') else gitsigns.diffthis() end end, { desc = 'Toggle Diff against index' }) end } }, { 'mfussenegger/nvim-dap', lazy = true, keys = { { '<F7>' } }, dependencies = { 'rcarriga/nvim-dap-ui', 'nvim-neotest/nvim-nio', 'williamboman/mason.nvim', 'jay-babu/mason-nvim-dap.nvim' }, config = function() local dap = require 'dap' local dapui = require 'dapui' dapui.setup() require('mason-nvim-dap').setup { automatic_installation = true, handlers = {}, ensure_installed = { 'codelldb' } } vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' }) vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' }) vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' }) vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' }) vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' }) vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' }) vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Toggle Debug UI' }) dap.listeners.after.event_initialized['dapui_config'] = dapui.open dap.listeners.before.event_terminated['dapui_config'] = dapui.close dap.listeners.before.event_exited['dapui_config'] = dapui.close end }, { 'nvimdev/dashboard-nvim', event = 'UIEnter', opts = function() local logo = ' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠘⢿⣦⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠀⣿⡎⠉⠉⠛⠻⣶⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⣿⠃⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠀⢻⣁⠀⠀⠀⠀⠈⢻⡆⠀⠠⣴⣤⣀⣠⣤⠀⢠⣾⡇⠀⢶⣴⠶⢿⠾⢷⣄⢿⡆⠀⠀⢹⡏⠀⠀⠀⠀⠀⢴⣶⡆⠀⠀⠰⣾⠟⠁⠀⠀⠀⠀⠀⣦⣄⣀⣿⣃⣀⣀⠀⠀⠀⠀⠀⠀\n ⠀⢸⡇⠀⢀⣀⡀⠀⢸⣿⡄⠀⣵⠀⠀⠈⠉⠀⢸⠏⢷⠀⠀⠀⠀⢸⡄⠀⠀⢸⡇⠀⠀⢸⡇⠀⠀⠀⠀⠀⢸⡿⠻⣆⠀⠀⣿⠀⠀⣠⡶⢶⣄⠀⠉⠉⠉⣿⠏⠉⠉⣶⣦⣤⡶⠶⣂\n ⠀⠀⣇⠀⠘⠛⠁⠀⠈⣿⣧⠀⣿⣠⣤⡤⣄⠀⣸⠀⣸⣆⣄⠀⠀⢸⡇⠀⠐⠚⡟⠋⠉⣽⠋⠀⠀⠀⠀⠀⢸⡇⠀⠘⣧⡀⢸⠀⣴⢋⣠⣄⢹⣦⠀⠀⣠⣿⠀⠀⠀⣿⡇⠀⠀⠀⠀\n ⠀⠀⣿⠀⠀⠀⠀⠀⢀⣿⠇⠀⣿⠀⠉⠉⠋⠀⣿⠿⠿⢿⡏⠀⠀⢸⡇⠀⠀⠀⡇⠀⠀⣿⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠹⣿⣸⡆⣿⠈⠙⠋⠀⣿⠀⠀⢹⡇⠀⠀⠀⢹⣷⣶⣤⣴⠀\n ⠀⠀⣿⠀⠀⠀⠀⣀⣼⠃⠀⢰⣧⣤⣤⣤⡄⢀⣿⠀⠀⢸⣧⠀⠀⣘⣿⠀⠀⠀⣿⠀⠀⢿⡀⠀⠀⠀⠀⠀⠸⣧⠀⠀⠀⠙⣿⡇⠹⢦⣤⣤⣾⠋⠀⠠⠼⠷⠀⠀⠀⢸⣿⠀⠀⠀⠀\n ⠀⢀⣿⣀⣤⣶⠿⠋⠀⠀⣀⣤⣶⣿⣿⣿⣷⣶⣶⣶⣤⡀⠀⠀⠀⠈⠙⠃⠀⠚⠛⠀⠀⠘⠉⠀⠀⠀⠀⠀⠚⠉⠀⠀⠀⣠⣬⣿⣶⣶⣾⣿⣿⣿⡿⠿⣶⣦⣤⡀⠀⣼⣿⣤⣤⣤⣄\n ⠀⢸⣿⠛⠁⠀⠀⣠⣶⠟⠛⢻⡟⠀⠈⢹⣿⠉⢹⣿⡿⣿⣦⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣿⣿⡿⢿⣿⡟⠁⢻⣿⠁⠀⠀⠀⣿⠉⠙⠳⣤⡀⠀⠀⠀⠀\n ⠀⠀⠀⠀⣠⠶⠋⠁⠀⠀⠀⠈⡇⠀⠀⠘⣿⠀⠀⢸⡇⠈⠻⣿⣿⣿⣷⣦⣤⣤⣄⡀⠀⠀⢀⡀⡀⡀⠀⣴⣿⠿⣿⣿⠀⡿⠀⢸⡏⠀⠀⢸⠃⠀⠀⠀⠀⠃⠀⠀⠀⠈⠉⢳⣄⠀⠀\n ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⠀⠀⠈⢿⠀⠀⠘⡟⠀⠀⠹⣿⢿⣿⣤⣀⣈⣿⣿⣿⣥⡾⠛⠉⠀⢸⡏⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠀⠀⠀⠇⠀⠀⠀⠻⠀⠀⣼⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠘⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣺⣿⢻⣿⣿⣿⠟⢻⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠇⣿⣿⣿⣿⣇⠘⢿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⣸⣿⣿⠿⣿⣿⠀⢻⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢙⡇⢿⣿⡇⠀⢻⣿⡄⢸⡗⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣟⣄⣿⡅⠀⠠⣿⣧⢾⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⣿⡇⠀⣼⣿⠛⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣇⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⢠⡿⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡾⢸⣿⡄⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⡼⠏⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n ' local opts = { theme = 'doom', hide = { statusline = true }, config = { header = vim.split(string.rep('\n', 15) .. logo, '\n'), center = { { action = '', desc = '', icon = '' } }, footer = {} } } return opts end }, { 'OXY2DEV/markview.nvim', ft = 'markdown', keys = { { '<leader>tm', '<cmd>Markview<cr>', desc = 'Toggle markdown view' } } }, { 'folke/tokyonight.nvim', event = 'VeryLazy', opts = { transparent = not vim.g.neovide, styles = { sidebars = 'transparent', floats = 'transparent' } } }, { 'rebelot/kanagawa.nvim', event = 'VeryLazy', opts = { transparent = not vim.g.neovide, colors = { theme = { all = { ui = { bg_gutter = 'none' } } } }, overrides = function() return { NormalFloat = { bg = 'none' }, FloatBorder = { bg = 'none' }, FloatTitle = { bg = 'none' } } end } }, { 'lukas-reineke/indent-blankline.nvim', event = 'UIEnter', main = 'ibl', opts = { indent = { char = '│' }, scope = { enabled = false }, exclude = { filetypes = { 'dashboard' } } } } } } -- The forbidden neovim config ʕっ-ᴥ•ʔ︻デ══━一 vim:noma:bt=nowrite
