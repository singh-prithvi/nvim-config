# 🧠 Neovim Config (LazyVim-based)

> Minimal, fast, and highly customized Neovim setup built on **LazyVim** with a focus on dev workflow, visuals, and control.

---

## ⚙️ Core Setup

- **Neovim Version:** `0.12+`
- **Base:** LazyVim
- **Plugin Manager:** lazy.nvim
- **OS:** Linux (Arch / Mint)

---

## 🎨 UI / Appearance

- **Primary Theme:** `catppuccin`
- **Fallback (default LazyVim):** `tokyonight`

### Dashboard
- Custom ASCII headers (e.g., *NEOVIM / LUNAR*)
- Powered by `alpha-nvim`

### System UI
- Transparency: `picom`
- Notifications: `dunst`

---

## 📦 Key Plugins

### Core UX
- `alpha-nvim` → dashboard
- `nvim-autopairs` → bracket completion
- `which-key.nvim` → keybinding hints

### Markdown
- `render-markdown.nvim` → inline rendering
- ❌ Removed: `markdown-preview.nvim` (browser-based)

### Dev
- LSP (via LazyVim)
- Treesitter
- Git via CLI

---

## ⚡ Customizations

### Fix Colorscheme Persistence
```lua
{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("catppuccin")
  end,
}
