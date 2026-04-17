-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Cursor shape per mode
vim.opt.guicursor = {
    "n-v-c:block-Cursor",
    "i-ci:ver25-Cursor",
    "r-cr:hor20-Cursor",
}

-- Re-apply the Cursor highlight every time a colorscheme loads,
-- because :colorscheme resets all highlights and would wipe this otherwise.
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("user_cursor_hl", { clear = true }),
    callback = function()
        vim.api.nvim_set_hl(0, "Cursor", { fg = "#1e1e2e", bg = "#89b4fa" })
    end,
})
-- Apply immediately for the first load as well
vim.api.nvim_exec_autocmds("ColorScheme", { group = "user_cursor_hl" })
