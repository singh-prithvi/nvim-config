-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

do
    vim.keymap.set("n", "<F5>", function() --Run your code in terminal
        if vim.bo.buftype == "terminal" then
            vim.cmd("wincmd p")
        end

        vim.cmd("w")

        local file = vim.fn.expand("%")

        local win = vim.g.cpp_term_win
        if win and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_current_win(win)
        else
            vim.cmd("botright split | resize 12 | terminal")
            vim.g.cpp_term_buf = vim.api.nvim_get_current_buf()
            vim.g.cpp_term_win = vim.api.nvim_get_current_win()
        end

        local chan = vim.b[vim.g.cpp_term_buf].terminal_job_id
        if chan then
            vim.fn.chansend(chan, "\003") -- Ctrl+C

            vim.defer_fn(function()
                local new_chan = vim.b[vim.g.cpp_term_buf].terminal_job_id

                if new_chan and vim.fn.jobwait({ new_chan }, 0)[1] == -1 then
                    vim.fn.chansend(new_chan, "clear\n")
                    vim.fn.chansend(new_chan, "echo Running: " .. file .. "\n")
                    vim.fn.chansend(new_chan, "g++ " .. file .. " -o out && ./out\n")
                else
                    -- restart terminal if dead
                    vim.cmd("bd! " .. vim.g.cpp_term_buf)
                    vim.cmd("botright split | resize 12 | terminal")
                    vim.g.cpp_term_buf = vim.api.nvim_get_current_buf()
                    vim.g.cpp_term_win = vim.api.nvim_get_current_win()

                    local restart_chan = vim.b[vim.g.cpp_term_buf].terminal_job_id
                    if restart_chan then
                        vim.fn.chansend(restart_chan, "clear\n")
                        vim.fn.chansend(restart_chan, "echo Running: " .. file .. "\n")
                        vim.fn.chansend(restart_chan, "g++ " .. file .. " -o out && ./out\n")
                    end
                end
            end, 100)
        end

        vim.cmd("wincmd p")
    end)

    vim.keymap.set({ "n", "t" }, "<C-k>", function() --Jump back and forth b/w code and terminal
        if vim.bo.buftype == "terminal" then
            return vim.cmd("wincmd p")
        end

        local win = vim.g.cpp_term_win
        if win and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_current_win(win)
        else
            print("No terminal window found. Press F5 first.")
        end
    end)
end
