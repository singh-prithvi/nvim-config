-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Group prevents duplicate autocmds if this file is ever re-sourced
local number_group = vim.api.nvim_create_augroup("user_number_toggle", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
    group = number_group,
    callback = function()
        vim.wo.relativenumber = false
        vim.wo.number = true
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = number_group,
    callback = function()
        vim.wo.relativenumber = true
        vim.wo.number = true
    end,
})
