-- lua/settings.lua
local o = vim.opt

o.number = true
o.relativenumber = true
o.termguicolors = true
o.cursorline = true
o.wrap = false
o.signcolumn = "yes"
o.scrolloff = 6

o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.splitbelow = true
o.splitright = true

-- search
o.ignorecase = true
o.smartcase = true

-- Aplica tema Saturn por cima do tokyonight
require("saturn_theme").apply()
