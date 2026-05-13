-- ─── Helpers ────────────────────────────────────────────────────────────────

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

-- ─── Runner ─────────────────────────────────────────────────────────────

vim.keymap.set({ "n", "i", "t" }, "<F5>", function()
    if vim.bo.buftype == "terminal" then
        vim.cmd("wincmd p")
    end

    local ft = vim.bo.filetype

    if ft ~= "cpp" and ft ~= "python" and ft ~= "rust" then
        return
    end

    vim.cmd("write")

    local file = vim.fn.shellescape(vim.fn.expand("%"))

    local win = vim.g.cpp_term_win

    if not (win and vim.api.nvim_win_is_valid(win)) then
        create_term()
    else
        vim.api.nvim_set_current_win(win)
    end

    local chan = vim.b[vim.g.cpp_term_buf].terminal_job_id

    if chan then
        vim.fn.chansend(chan, "\003")

        vim.defer_fn(function()
            local new_chan = vim.b[vim.g.cpp_term_buf].terminal_job_id

            if new_chan and vim.fn.jobwait({ new_chan }, 0)[1] == -1 then
                run_file_in_chan(new_chan, file, ft)
            else
                vim.cmd("bd! " .. vim.g.cpp_term_buf)

                create_term()

                local restart_chan = vim.b[vim.g.cpp_term_buf].terminal_job_id

                if restart_chan then
                    run_file_in_chan(restart_chan, file, ft)
                end
            end
        end, 100)
    else
        vim.defer_fn(function()
            local new_chan = vim.b[vim.g.cpp_term_buf].terminal_job_id

            if new_chan then
                run_file_in_chan(new_chan, file, ft)
            end
        end, 150)
    end

    vim.cmd("wincmd p")
end, { desc = "Run current file (C++ / Python / Rust)" })
