-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Cursor style
vim.opt.guicursor = {
    "n-v-c:block-Cursor",
    "i-ci:ver25-Cursor",
    "r-cr:hor20-Cursor",
}

-- Cursor highlight (color)
vim.api.nvim_set_hl(0, "Cursor", { fg = "#1e1e2e", bg = "#89b4fa" })
