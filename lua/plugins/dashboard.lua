return {
    {
        "folke/snacks.nvim",
        opts = function(_, opts)
            local lines = {
                "You don't understand it, you just memorized it.",
                "It works… but you have no idea why.",
                "Your code runs by accident, not by design.",
                "You Google more than you think.",
                "Copy-paste driven development.",
                "You fix bugs by adding more bugs.",
                "You pray before running your code.",
                "Stack Overflow is your real brain.",
                "You debug by print statements only.",
                "Your variable names tell no story.",
                "You fear touching your own code.",
                "You don't optimize, you hope.",
                "Your logic works… until it doesn't.",
                "You code fast, but think slow.",
                "Deep down, you know this is true.",
                "You don't write code, you negotiate with errors.",
                "Your 'fix' is just moving the problem somewhere else.",
                "You don't debug, you guess better over time.",
                "If it works, don't touch it… because you'll break it.",
                "You don't fix bugs, you just make them harder to find.",
                "Your code compiles, but so do bad decisions.",
                "You're not done, you just stopped debugging.",
                "Every fix you make creates two new problems.",
                "You don't understand the bug, you just silenced it.",
                "You write code like you're racing, but debugging proves you're not winning.",
                "You don't build features, you accumulate technical debt.",
                "You spend hours debugging something a senior would fix in minutes.",
                "Your solution works, but it's not the right one.",
                "You rely on luck more than logic.",
                "Your code passes tests you didn't write properly.",
                "You don't control your codebase, it controls you.",
                "You rewrite code not to improve it, but because you forgot how it works.",
                "You debug symptoms while ignoring the real problem.",
                "Half your code is 'temporary' from 6 months ago.",
                "You trust code you don't understand way too much.",
                "You write comments for things you should've named properly.",
                "Your code only works on your machine… barely.",
                "You fear refactoring because you know it'll break everything.",
                "You spend more time fixing than building.",
                "Your commits say 'fix' because you don't know what you fixed.",
                "You don't solve problems, you patch symptoms.",
                "You rely on autocomplete more than your brain.",
                "You've never fully understood your own project.",
                "You think it's optimized… it's not.",
                "You're one bug away from losing control.",
                "You say you're good at handling exceptions… just not in life.",
                "You love breaking things… especially in production.",
                "You're great at committing… just not relationships.",
                "You keep pushing… even when no one asked you to.",
                "You know how to handle threads… but still lose focus.",
                "You deal with memory leaks… but forget everything else.",
                "You optimize performance… but not your own time.",
                "You always return something… except effort.",
                "You handle multiple arguments… but never win them.",
                "You like to go deep… but only in nested loops.",
                "You debug code all day… but can't fix your own mistakes.",
                "You keep things running… just not your life.",
                "You chase performance… while wasting your own potential.",
                "You know how to handle crashes… just not failure.",
                "You refactor code… but never yourself.",
                "You solve problems… until they involve thinking.",
                "You rely on logic… until it's time to use it.",
                "You write efficient code… and live inefficiently.",
                "You build systems… but can't build discipline.",
                "You fix errors… but ignore the obvious ones in yourself.",
            }

            math.randomseed(vim.uv.hrtime())
            local line = lines[math.random(#lines)]

            opts.dashboard = vim.tbl_deep_extend("force", opts.dashboard or {}, {
                preset = {
                    header = [[
███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
                    ]],
                },

                sections = {
                    { section = "header" },
                    { section = "keys", gap = 1, padding = 1 },
                    { text = line, align = "center" },
                    { gap = 1 },
                    { section = "startup", align = "center" },
                },
            })

            return opts
        end,
    },
}
