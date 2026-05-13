-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Time (ms) to wait for mapped key sequences (jk → Esc)
vim.opt.timeoutlen = 200

-- indentation
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function()
        vim.opt_local.shiftwidth = 8
        vim.opt_local.tabstop = 8
        vim.opt_local.softtabstop = 8
    end,
})
