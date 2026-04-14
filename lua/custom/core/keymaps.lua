-- lua/custom/core/keymaps.lua

-- ── General ──────────────────────────────────────────────────────────
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })

-- NOTE: <leader>q was set in init.lua as `vim.diagnostic.setloclist`.
-- We intentionally override it here to be a quick quit instead.
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })

-- File explorer (requires neo-tree in custom/plugins/ui.lua)
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle file tree' })

-- ── C++ Build & Run ──────────────────────────────────────────────────
vim.keymap.set('n', '<F5>', function()
  vim.cmd 'w'
  local file = vim.fn.expand '%'

  local term_buf = vim.g.cpp_term_buf
  local term_win = vim.g.cpp_term_win

  -- Reuse existing terminal window if it's still open
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_set_current_win(term_win)
  else
    vim.cmd 'botright split | resize 12'
    vim.cmd 'terminal'
    term_buf = vim.api.nvim_get_current_buf()
    term_win = vim.api.nvim_get_current_win()
    vim.g.cpp_term_buf = term_buf
    vim.g.cpp_term_win = term_win
  end

  local chan = vim.b[term_buf].terminal_job_id
  if chan then
    vim.fn.chansend(chan, 'clear\n')
    vim.fn.chansend(chan, 'echo "Running: ' .. file .. '"\n')
    vim.fn.chansend(chan, 'g++ -std=c++17 ' .. file .. ' -o out && ./out\n')
  end

  vim.cmd 'wincmd p' -- return focus to code buffer
end, { desc = 'Compile & run C++ file' })

-- ── Telescope / File search ───────────────────────────────────────────
-- NOTE: kickstart already sets <leader>sf, <leader>sg, <leader>sh, etc.
-- The <ff> / <fg> / <fb> variants below are extra shortcuts — no conflict.
-- BUT: kickstart maps <leader>sh → help_tags.
--      We map <leader>sh → horizontal split below → this OVERRIDES kickstart's binding.
--      Rename one if you want both (e.g. <leader>th for horizontal split).
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'Help Tags' })
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<CR>', { desc = 'Recent Files' })
vim.keymap.set('n', '<leader>fc', '<cmd>Telescope commands<CR>', { desc = 'Commands' })
vim.keymap.set('n', '<leader>fk', '<cmd>Telescope keymaps<CR>', { desc = 'Keymaps' })

-- ── LSP ───────────────────────────────────────────────────────────────
-- Wrapped in LspAttach so they only apply in buffers where an LSP is active.
-- Kickstart already sets grn, gra, grr, gri, grd, grt, grD via LspAttach.
-- The bindings below add convenience aliases; adjust to taste.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('custom-lsp-keymaps', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc) vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }) end

    map('gd', vim.lsp.buf.definition, 'Go to Definition')
    map('gD', vim.lsp.buf.declaration, 'Go to Declaration')
    map('gi', vim.lsp.buf.implementation, 'Go to Implementation')
    map('K', vim.lsp.buf.hover, 'Hover Docs')
    map('<leader>rn', vim.lsp.buf.rename, 'Rename Symbol')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
  end,
})

-- Diagnostic navigation
vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1 } end, { desc = 'Prev Diagnostic' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1 } end, { desc = 'Next Diagnostic' })

-- ── Buffers ───────────────────────────────────────────────────────────
vim.keymap.set('n', '<leader>bb', '<cmd>Telescope buffers<CR>', { desc = 'Switch Buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete Buffer' })
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Prev Buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next Buffer' })

-- ── Window splits ─────────────────────────────────────────────────────
-- <leader>sh would conflict with kickstart's Telescope help_tags.
-- Renamed to <leader>ws* (Window Split) to avoid the collision.
vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = 'Vertical Split' })
vim.keymap.set('n', '<leader>ss', '<cmd>split<CR>', { desc = 'Horizontal Split' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Equalize splits' })
vim.keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close Split' })

-- ── Treesitter incremental selection ─────────────────────────────────
-- NOTE: The old config had TWO identical <c-space> mappings for normal mode
-- (init_selection AND node_incremental), so the first was silently overwritten.
--
-- The module path `nvim-treesitter.incremental_selection` does NOT exist in the
-- new kickstart treesitter (branch = 'main'). Those keymaps would error at runtime.
--
-- The new API uses `vim.treesitter` directly. Treesitter text-object selection is
-- handled by mini.ai (already in kickstart). For manual incremental selection,
-- configure it inside the treesitter plugin spec — see nvim-treesitter docs.
-- Removed the broken keymaps here to prevent runtime errors.

-- ── Switch b/w cursor style presets─────────────────────────────────────────────────────
