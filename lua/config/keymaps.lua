-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ─── Helpers ────────────────────────────────────────────────────────────────

-- Open a new bottom terminal split and record its buf/win in globals
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.g.cpp_term_buf = nil
        vim.g.cpp_term_win = nil
    end,
})

local function create_term()
    vim.cmd("botright split | resize 12 | terminal")
    vim.g.cpp_term_buf = vim.api.nvim_get_current_buf()
    vim.g.cpp_term_win = vim.api.nvim_get_current_win()
end

-- Send compile-and-run commands to an already-live terminal channel.
-- `file` should already be shell-escaped before being passed in.
local function run_file_in_chan(chan, file, ft)
    vim.fn.chansend(chan, "clear && printf '\\033[3J'\n")
    vim.fn.chansend(chan, "echo 'Running: " .. file .. "'\n")
    if ft == "cpp" then
        vim.fn.chansend(chan, "g++ " .. file .. " -o out && ./out\n")
    elseif ft == "python" then
        vim.fn.chansend(chan, "python3 " .. file .. "\n")
    elseif ft == "rust" then
        if vim.fn.filereadable(vim.fn.expand("%:p:h") .. "/Cargo.toml") == 1 then
            vim.fn.chansend(chan, "cargo run\n")
        else
            vim.fn.chansend(chan, "rustc " .. file .. " -o out && ./out\n")
        end
    end
end

-- ─── C++ Runner ─────────────────────────────────────────────────────────────

-- F5: write and run the current C++ file in a persistent bottom terminal
vim.keymap.set({ "n", "i", "t" }, "<F5>", function()
    if vim.bo.buftype == "terminal" then
        vim.cmd("wincmd p")
    end

    local ft = vim.bo.filetype
    if ft ~= "cpp" and ft ~= "python" and ft ~= "rust" then
        return
    end
    -- If somehow triggered from the terminal itself, hop back to code first

    vim.cmd("write")
    -- Shellescape so filenames with spaces or special chars don't break the shell command
    local file = vim.fn.shellescape(vim.fn.expand("%"))

    -- Reuse the existing terminal window, or open a fresh one
    local win = vim.g.cpp_term_win
    if not (win and vim.api.nvim_win_is_valid(win)) then
        create_term()
    else
        vim.api.nvim_set_current_win(win)
    end

    local chan = vim.b[vim.g.cpp_term_buf].terminal_job_id

    if chan then
        -- Terminal already running: interrupt whatever's going, then compile
        vim.fn.chansend(chan, "\003") -- Ctrl-C

        vim.defer_fn(function()
            local new_chan = vim.b[vim.g.cpp_term_buf].terminal_job_id
            -- jobwait returns -1 while the job is still alive
            if new_chan and vim.fn.jobwait({ new_chan }, 0)[1] == -1 then
                run_file_in_chan(new_chan, file, ft)
            else
                -- Job died unexpectedly; blow away the old buf and restart
                vim.cmd("bd! " .. vim.g.cpp_term_buf)
                create_term()
                local restart_chan = vim.b[vim.g.cpp_term_buf].terminal_job_id
                if restart_chan then
                    run_file_in_chan(restart_chan, file, ft)
                end
            end
        end, 100)
    else
        -- The terminal process hasn't started yet, so we defer and wait for it.
        vim.defer_fn(function()
            local new_chan = vim.b[vim.g.cpp_term_buf].terminal_job_id
            if new_chan then
                run_file_in_chan(new_chan, file, ft)
            end
        end, 150)
    end

    vim.cmd("wincmd p") -- return focus to the code window
end, { desc = "Run current file (C++ / Python / Rust)" })

-- ─── Terminal Toggle ─────────────────────────────────────────────────────────

-- Ctrl-K: jump to the terminal from code, or back to code from the terminal
vim.keymap.set({ "n", "i", "t" }, "<leader>k", function()
    if vim.bo.buftype == "terminal" then
        vim.cmd("wincmd p")
        return
    end
    local win = vim.g.cpp_term_win
    if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_set_current_win(win)
    else
        vim.notify("No terminal open — press F5 first.", vim.log.levels.WARN)
    end
end, { desc = "Toggle code/terminal focus" })

-- ─── Insert-mode Escape from Pairs Mislennious──────────────────────────────────────────

-- Ctrl-L: if the cursor is sitting just before a closing bracket or quote,
-- jump past it instead of inserting a literal Ctrl-L.
vim.keymap.set("i", "<C-l>", function()
    local col = vim.fn.col(".")
    local line = vim.api.nvim_get_current_line()
    if line:sub(col, col):match("[%)%}%]\"']") then
        return "<Right>"
    end
    return "<C-l>"
end, { expr = true, silent = true, desc = "Jump past closing pair" })

-- ─── Miscellaneous ─────────────────────────────────────────────────────────────────────

-- Esc via j+k keymap
vim.keymap.set("i", "jk", function()
    local col = vim.fn.col(".") - 1
    local line = vim.fn.getline(".")

    -- Check previous character
    if col > 0 then
        local prev_char = line:sub(col, col)

        -- If previous char is a letter → don't escape
        if prev_char:match("%a") then
            return "jk"
        end
    end

    return "<Esc>"
end, { expr = true, noremap = true, silent = true })

-- 🌐 Browser-like tab controls
vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<cr>", { desc = "New tab" }) -- New tab

vim.keymap.set("n", "<leader>tc", function() -- Closes the current tab
    local current_buf = vim.api.nvim_get_current_buf()
    local current_ft = vim.bo[current_buf].filetype
    -- 🚫 NEVER close Neo-tree
    if current_ft == "snacks_explorer" then
        vim.notify("Explorer can't be closed with this", vim.log.levels.WARN)
        return
    end
    local real_bufs = {}
    for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
        if vim.bo[buf.bufnr].filetype ~= "snacks_explorer" then
            table.insert(real_bufs, buf.bufnr)
        end
    end
    local tabs = vim.fn.tabpagenr("$")
    -- 🧠 If last tab + last buffer → quit (with save prompt)
    if #real_bufs == 1 and tabs == 1 then
        vim.cmd("confirm q")
        return
    end
    -- Normal behavior
    if #real_bufs > 1 then
        vim.cmd("bnext")
        vim.cmd("confirm bd " .. current_buf)
    else
        vim.cmd("enew")
    end
end, { desc = "Close buffer (smart)" })

vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Only this tab" }) -- Close other tabs
for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", {
        desc = "Go to buffer " .. i,
    })
end
