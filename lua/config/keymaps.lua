-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ─── Helpers ────────────────────────────────────────────────────────────────

-- Open a new bottom terminal split and record its buf/win in globals
local function create_term()
    vim.cmd("botright split | resize 12 | terminal")
    vim.g.cpp_term_buf = vim.api.nvim_get_current_buf()
    vim.g.cpp_term_win = vim.api.nvim_get_current_win()
end

-- Send compile-and-run commands to an already-live terminal channel.
-- `file` should already be shell-escaped before being passed in.
local function run_file_in_chan(chan, file)
    vim.fn.chansend(chan, "clear\n")
    vim.fn.chansend(chan, "echo 'Running: " .. file .. "'\n")
    vim.fn.chansend(chan, "g++ " .. file .. " -o out && ./out\n")
end

-- ─── C++ Runner ─────────────────────────────────────────────────────────────

-- F5: write and run the current C++ file in a persistent bottom terminal
vim.keymap.set("n", "<F5>", function()
    -- If somehow triggered from the terminal itself, hop back to code first
    if vim.bo.buftype == "terminal" then
        vim.cmd("wincmd p")
    end

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
                run_file_in_chan(new_chan, file)
            else
                -- Job died unexpectedly; blow away the old buf and restart
                vim.cmd("bd! " .. vim.g.cpp_term_buf)
                create_term()
                local restart_chan = vim.b[vim.g.cpp_term_buf].terminal_job_id
                if restart_chan then
                    run_file_in_chan(restart_chan, file)
                end
            end
        end, 100)
    else
        -- The terminal process hasn't started yet, so we defer and wait for it.
        vim.defer_fn(function()
            local new_chan = vim.b[vim.g.cpp_term_buf].terminal_job_id
            if new_chan then
                run_file_in_chan(new_chan, file)
            end
        end, 150)
    end

    vim.cmd("wincmd p") -- return focus to the code window
end, { desc = "Run C++ file" })

-- ─── Terminal Toggle ─────────────────────────────────────────────────────────

-- Ctrl-K: jump to the terminal from code, or back to code from the terminal
vim.keymap.set({ "n", "t" }, "<C-k>", function()
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

-- ─── Insert-mode Escape from Pairs ──────────────────────────────────────────

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
