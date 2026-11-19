-- ─── options ──────────────────────────────────────────────────────────────
vim.g.mapleader = ' '

vim.opt.number = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.cmdheight = 0
vim.opt.laststatus = 3
vim.opt.showmode = false

-- ─── plugins ──────────────────────────────────────────────────────────────
vim.pack.add {
    { src = "https://github.com/catppuccin/nvim",                          name = "catppuccin" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/saghen/blink.cmp",                         version = vim.version.range('*') },
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/nvim-tree/nvim-tree.lua" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/sindrets/diffview.nvim" },
    { src = "https://github.com/NeogitOrg/neogit" },
    { src = "https://github.com/folke/lazydev.nvim" },
    { src = "https://github.com/coder/claudecode.nvim" },
}

-- ─── colorscheme ──────────────────────────────────────────────────────────
vim.cmd.colorscheme "catppuccin-mocha"

-- ─── lsp ──────────────────────────────────────────────────────────────────
require('lazydev').setup({
    library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
})

require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { 'pyright', 'ruff', 'clangd', 'lua_ls', 'neocmake' },
    automatic_enable = true,
})

vim.lsp.config('neocmake', {
    cmd = { 'neocmakelsp', 'stdio' },
})

-- ─── completion ───────────────────────────────────────────────────────────
require('blink.cmp').setup({
    keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    },
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        },
    },
    signature = { enabled = true },
})

-- ─── file tree ────────────────────────────────────────────────────────────
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require('nvim-tree').setup()

-- ─── statusline ───────────────────────────────────────────────────────────
require('lualine').setup({
    options = {
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
        globalstatus = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_y = {},
        lualine_z = {},
    },
})

-- ─── telescope ────────────────────────────────────────────────────────────
require('telescope').setup({
    defaults = {
        mappings = {
            i = {
                ['<C-j>'] = 'move_selection_next',
                ['<C-k>'] = 'move_selection_previous',
            },
        },
    },
})

-- ─── git ──────────────────────────────────────────────────────────────────
require('gitsigns').setup({
    signs = {
        add          = { text = '▍' },
        change       = { text = '▍' },
        delete       = { text = '▁' },
        topdelete    = { text = '▔' },
        changedelete = { text = '▍' },
        untracked    = { text = '▍' },
    },
    numhl = true,
    current_line_blame = false,
})

require('diffview').setup()
require('neogit').setup({})
require('claudecode').setup()


-- ─── diagnostics ──────────────────────────────────────────────────────────
vim.diagnostic.config({
    virtual_text = {
        spacing = 4,
        prefix = '●',
    },
    severity_sort = true,
    float = {
        border = 'rounded',
        source = true,
    },
})

-- ─── keymaps ──────────────────────────────────────────────────────────────
local map = vim.keymap.set
local tb = require('telescope.builtin')

-- config
map('n', '<leader>r', '<cmd>source $MYVIMRC<CR>', { desc = 'Reload config' })

-- clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- file tree
map('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file tree' })

-- theme toggle
map('n', '<leader>tt', function()
    if vim.g.colors_name == 'catppuccin-latte' then
        vim.cmd.colorscheme 'catppuccin-mocha'
    else
        vim.cmd.colorscheme 'catppuccin-latte'
    end
end, { desc = 'Toggle light/dark theme' })

-- format
map({ 'n', 'v' }, '<leader>f', function()
    vim.lsp.buf.format({ async = true })
end, { desc = 'Format buffer' })

-- git (gitsigns)
local gs = require('gitsigns')
map('n', ']c', function() gs.nav_hunk('next') end, { desc = 'Next hunk' })
map('n', '[c', function() gs.nav_hunk('prev') end, { desc = 'Prev hunk' })
map('n', '<leader>gp', gs.preview_hunk, { desc = 'Preview hunk' })
map('n', '<leader>gs', gs.stage_hunk, { desc = 'Stage hunk' })
map('v', '<leader>gs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Stage selected lines' })
map('n', '<leader>gr', gs.reset_hunk, { desc = 'Reset hunk' })
map('v', '<leader>gr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Reset selected lines' })
map('n', '<leader>gb', gs.blame_line, { desc = 'Blame line' })
map('n', '<leader>gd', gs.diffthis, { desc = 'Diff this' })
map('n', '<leader>gt', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
map('n', '<leader>gg', '<cmd>Neogit<CR>', { desc = 'Neogit' })

-- claude code
map('n', '<leader>ac', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude' })
map('n', '<leader>af', '<cmd>ClaudeCodeFocus<CR>', { desc = 'Focus Claude' })
map('n', '<leader>ar', '<cmd>ClaudeCode --resume<CR>', { desc = 'Resume Claude' })
map('n', '<leader>aC', '<cmd>ClaudeCode --continue<CR>', { desc = 'Continue Claude' })
map('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<CR>', { desc = 'Add current buffer' })
map('v', '<leader>as', '<cmd>ClaudeCodeSend<CR>', { desc = 'Send selection to Claude' })
map('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Terminal: go left' })
map('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Terminal: go right' })
map('n', '<leader>aa','<cmd>ClaudeCodeDiffAccept<CR>', { desc = 'Accept diff' })
map('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<CR>', { desc = 'Deny diff' })

-- telescope
map('n', '<leader>sf', tb.find_files, { desc = 'Find files' })
map('n', '<leader>sg', tb.live_grep, { desc = 'Live grep' })
map('n', '<leader>sb', tb.buffers, { desc = 'Buffers' })
map('n', '<leader>sh', tb.help_tags, { desc = 'Help' })
map('n', '<leader>sr', tb.resume, { desc = 'Resume last picker' })
map('n', '<leader>sd', tb.diagnostics, { desc = 'Diagnostics' })
