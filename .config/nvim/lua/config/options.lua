-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Disable autoformat on save globally (LazyVim feature)
vim.g.autoformat = false

-- General settings
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Better search
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Visual
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.colorcolumn = "120"
opt.wrap = false

-- Indentation (defaults, overridden by filetype-specific settings)
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smartindent = true

-- Performance
opt.updatetime = 50
opt.timeoutlen = 300

-- Better completion experience
opt.completeopt = "menu,menuone,noselect"

-- Split behavior
opt.splitbelow = true
opt.splitright = true

-- Cursor line
opt.cursorline = true

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Enable mouse support
opt.mouse = "a"

-- Clipboard
opt.clipboard = "unnamedplus"

-- LSP Diagnostics Icons
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
