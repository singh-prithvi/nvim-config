-- lua/custom/plugins/init.lua
--
-- lazy.nvim's `{ import = 'custom.plugins' }` already scans this entire directory
-- and loads ui.lua, cpp.lua, etc. on its own.
--
-- DO NOT re-require those files here with `require 'custom.plugins.ui'` — it causes
-- double-loading and nested-spec confusion.
--
-- Put plugins here that don't belong in ui.lua or cpp.lua.

return {
  -- Dashboard / start screen
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      dashboard.section.header.val = {
        '███╗   ██╗██╗   ██╗██╗███╗   ███╗',
        '████╗  ██║██║   ██║██║████╗ ████║',
        '██╔██╗ ██║██║   ██║██║██╔████╔██║',
        '██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║',
        '██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║',
        '╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝',
      }

      dashboard.section.buttons.val = {
        dashboard.button('f', '  Find file', ':Telescope find_files<CR>'),
        dashboard.button('n', '  New file', ':ene <CR>'),
        dashboard.button('r', '  Recent files', ':Telescope oldfiles<CR>'),
        dashboard.button('g', '  Find text', ':Telescope live_grep<CR>'),
        dashboard.button('c', '  Config', ':e ~/.config/nvim/init.lua<CR>'),
        dashboard.button('l', '󰒲  Lazy', ':Lazy<CR>'),
        dashboard.button('q', '  Quit', ':qa<CR>'),
      }

      dashboard.section.footer.val = function()
        local jokes = {
          'Why do programmers prefer dark mode? Because light attracts bugs 🐛',
          'There are 10 types of people: those who understand binary and those who don\'t',
          'Segmentation fault (core dumped) 💀',
          'It works on my machine 🤡',
          'Fix one bug, create two more 🔥',
          '99 little bugs in the code... patch one around… 127 bugs 🫠',
          'You didn\'t fix the bug, you just hid it better 🫠',
          'Your TODO list has TODOs inside it 📋',
          'That one function… even you\'re scared to touch it 😬',
          'Your \'temporary fix\' has been there for 6 months ⏳',
        }

        dashboard.opts.layout = {
          { type = 'padding', val = 8 },
          {
            type = 'group',
            val = {
              dashboard.section.header,
              { type = 'padding', val = 2 },
              dashboard.section.buttons,
              { type = 'padding', val = 2 },
              dashboard.section.footer,
            },
            opts = { position = 'center' },
          },
        }

        math.randomseed(os.time())
        return '💡 ' .. jokes[math.random(#jokes)]
      end

      alpha.setup(dashboard.opts)
    end,
  },
}
