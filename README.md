🧠 Neovim Config (LazyVim-based)

Minimal, fast, and highly customized Neovim setup built on LazyVim with a focus on dev workflow, visuals, and control.

⚙️ Core Setup
Neovim Version: 0.12+
Base: LazyVim
Plugin Manager: lazy.nvim
OS: Linux (Arch / Mint)
🎨 UI / Appearance
Primary Theme: catppuccin
Fallback (default LazyVim): tokyonight
Custom dashboard with:
ASCII headers (custom text like NEOVIM / LUNAR)
Alpha dashboard plugin
Transparency + compositor support:
picom (for blur/transparency)
Notifications:
dunst
📦 Key Plugins
Core UX
alpha-nvim → dashboard
nvim-autopairs → bracket completion
which-key.nvim → keybinding hints
Markdown / Preview
render-markdown.nvim (lazy-loaded, all filetypes tweak)
(Removed) markdown-preview.nvim → replaced due to browser dependency
Dev Experience
LSP via LazyVim defaults
Treesitter for syntax highlighting
Git integration (basic CLI workflow)
⚡ Customizations
Colorscheme Fix
-- Ensures catppuccin persists
{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("catppuccin")
  end,
}
Dashboard Header Example
dashboard.section.header.val = {
  [[  ^  ^  ^   ^☆ ★ ☆ ___I_☆ ★ ☆ ^  ^   ^  ^  ^   ^  ^ ]],
  [[ /|\/|\/|\ /|\ ★☆ /\-_--\ ☆ ★/|\/|\ /|\/|\/|\ /|\/|\ ]],
}
Markdown Rendering (All Files)
Forced rendering outside Lazy window
Lazy loading adjusted for global use
🧠 Philosophy
Keep it minimal but powerful
Avoid plugins that:
open browsers unnecessarily
break workflow consistency
Prefer native + Lua configs over heavy abstractions
🚀 Workflow
Git CLI usage:
git add .
manual branch handling
Config stored in:
~/.config/nvim
🧩 Known Issues / Fixes
Colorscheme reverting → fixed via priority + config
Markdown not rendering → fixed lazy loading scope
Dashboard conflicts → resolved duplicate plugin issue
🔥 Future Plans
Better dashboard (dynamic quotes / system info)
More aggressive lazy-loading optimization
Custom keymaps for faster navigation
Possibly switch to fully custom config (away from LazyVim base)
📁 Repo Structure
nvim/
├── lua/
│   ├── plugins/
│   ├── config/
│   └── core/
├── init.lua
└── lazy-lock.json
💀 Vibe

Clean UI. Fast startup. No nonsense plugins.
If it slows me down, it’s gone.
