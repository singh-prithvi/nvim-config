return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                clangd = {
                    cmd = { "clangd", "--background-index" },
                },

                pyright = {},

                rust_analyzer = {},
            },
        },
    },

    {
        "mason-org/mason.nvim",
        opts = {
            ensure_installed = {
                "clangd",
                "pyright",
                "rust-analyzer",
            },
        },
    },
}
