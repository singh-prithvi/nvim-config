-- lua/custom/plugins/cpp.lua
-- C++ development support.
--
-- HOW CLANGD WORKS WITH THIS KICKSTART SETUP
-- -------------------------------------------
-- Kickstart's LSP config (in init.lua) uses neovim 0.11's native LSP API:
--   vim.lsp.config(name, server_config)
--   vim.lsp.enable(name)
--
-- You CANNOT add servers by passing `opts = { servers = { clangd = {} } }` to the
-- nvim-lspconfig lazy spec — kickstart's `config = function()` ignores that opts table.
--
-- OPTIONS (pick one):
--
-- ✅ OPTION A (recommended): Uncomment `clangd = {}` in init.lua's servers table.
--    Mason will auto-install clangd and the LSP will work out of the box.
--    Look for the line:   -- clangd = {},   around line 570 in init.lua.
--
-- ✅ OPTION B: Use neovim's native LSP API directly (done below).
--    clangd must be on your PATH (installed via `apt install clangd` or Mason manually).
--    Mason will NOT auto-install it with this approach.

vim.lsp.config('clangd', {
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--header-insertion=iwyu',
    '--completion-style=detailed',
  },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
})
vim.lsp.enable 'clangd'

-- Remove the OLD broken entries that were here before:
--   { 'neovim/nvim-lspconfig', opts = { servers = { clangd = {} } } }  ← DID NOTHING
--   { 'williamboman/mason.nvim', opts = {} }        ← WRONG ORG, conflicts with mason-org/mason.nvim
--   { 'williamboman/mason-lspconfig.nvim', opts = {} } ← same issue
--   { 'hrsh7th/nvim-cmp' }, { 'saadparwaiz1/cmp_luasnip' }, { 'hrsh7th/cmp-nvim-lsp' }
--       ← kickstart already uses saghen/blink.cmp; adding nvim-cmp without a config
--         function means it's installed but never wired up — dead weight.
--   { 'nvim-treesitter/nvim-treesitter', opts = { ensure_installed = {...} } }
--       ← kickstart's treesitter uses the new branch='main' API which ignores this opts.
--   { 'lewis6991/gitsigns.nvim', opts = {} }
--       ← already in main init.lua; duplicate entry.

return {} -- no lazy plugin specs needed; LSP wired up directly above
