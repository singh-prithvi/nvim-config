-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Group prevents duplicate autocmds if this file is ever re-sourced
local number_group = vim.api.nvim_create_augroup("user_number_toggle", { clear = true })

-- Show absolute line numbers in insert mode, relative in normal mode
vim.api.nvim_create_autocmd("InsertEnter", {
    group = number_group,
    callback = function()
        vim.opt.relativenumber = false
        vim.opt.number = true
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = number_group,
    callback = function()
        vim.opt.relativenumber = true
        vim.opt.number = true
    end,
})
