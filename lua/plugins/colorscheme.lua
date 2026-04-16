return {
    -- set colorscheme for LazyVim
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin",
        },
    },

    -- install catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha",
            transparent_background = true,
        },
    },
    {
        "folke/tokyonight.nvim",
        lazy = true, -- don't load automatically
    },
}
