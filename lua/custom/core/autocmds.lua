-- lua/custom/core/autocmds.lua
-- Custom autocommands go here.
-- Kickstart already defines: highlight-on-yank, lsp-highlight, lsp-detach.

-- Example: auto-close the terminal when the process exits
vim.api.nvim_create_autocmd('TermClose', {
  desc = 'Close terminal buffer automatically when process exits',
  group = vim.api.nvim_create_augroup('custom-term-close', { clear = true }),
  callback = function()
    -- Only auto-close if it was our cpp runner terminal
    if vim.g.cpp_term_buf == vim.api.nvim_get_current_buf() then
      vim.g.cpp_term_buf = nil
      vim.g.cpp_term_win = nil
    end
  end,
})

-- Example: set C++ specific options when entering a C/C++ file
vim.api.nvim_create_autocmd('FileType', {
  desc = 'C/C++ file settings',
  group = vim.api.nvim_create_augroup('custom-cpp-ft', { clear = true }),
  pattern = { 'c', 'cpp' },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})
