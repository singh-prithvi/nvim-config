return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                clangd = {
                    cmd = { "clangd", "--background-index", "--clang-tidy" },
                },
            },
        },
    },

    {
        "mason-org/mason.nvim",
        opts = {
            ensure_installed = { "clangd" },
        },
    },
}
