-- Entry point for all custom config.
-- lazy.nvim already handles loading custom.plugins via `{ import = 'custom.plugins' }`.
-- Do NOT require custom.plugins here — it causes double-loading.

require 'custom.core.options'
require 'custom.core.keymaps'
require 'custom.core.autocmds'
