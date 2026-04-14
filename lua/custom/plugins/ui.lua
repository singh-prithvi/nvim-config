-- =========================================================
-- 🎨 UI / Visual Plugins
-- lua/custom/plugins/ui.lua
-- =========================================================

-- ======================
-- 🧠 Cursor Presets
-- ======================
local presets = {
  smooth = {
    stiffness = 0.5,
    trailing_stiffness = 0.3,
    distance_stop_animating = 0.4,
    time_interval = 17,
    cursor_color = '#7aa2f7',
  },

  fast = {
    stiffness = 0.9,
    trailing_stiffness = 0.8,
    smear_between_buffers = false,
    cursor_color = '#7aa2f7',
  },

  dramatic = {
    stiffness = 0.3,
    trailing_stiffness = 0.2,
    distance_stop_animating = 0.2,
    cursor_color = '#7aa2f7',
  },
}

-- 👉 Choose active preset
local chosen = presets.fast

-- =========================================================
-- 📦 Plugin Specs
-- =========================================================
return {

  -- ======================
  -- ✨ Cursor Animation
  -- ======================
  {
    'sphamba/smear-cursor.nvim',
    event = 'VeryLazy',
    opts = chosen,
  },

  -- ======================
  -- 📊 Status Line
  -- ======================
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  -- ======================
  -- 📁 File Explorer
  -- ======================
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = 'Neotree',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    opts = {
      window = { width = 25 },
    },
  },
}
