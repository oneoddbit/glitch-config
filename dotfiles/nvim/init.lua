-- ======================
-- init.lua - Neovim Config
-- ======================

-- =========
-- Settings
-- =========
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- =========
-- Keymaps
-- =========
vim.g.mapleader = " "
local map = vim.keymap.set
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "List buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>e", "<cmd>Ex<cr>", { desc = "File explorer" })

-- =========
-- Plugin Manager: lazy.nvim
-- =========
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Estilo e cores
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },

  -- Navegação e Fuzzy Finder
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- LSP + Autocomplete
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" } },

  -- Syntax Highlight avançado
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Integração fzf + zoxide
  { "ibhagwan/fzf-lua" },
  { "jvgrootveld/telescope-zoxide" },

  -- Statusline minimal
  { "nvim-lualine/lualine.nvim" },
})

-- =========
-- Colorscheme
-- =========
vim.cmd[[colorscheme tokyonight]]

-- =========
-- LSP
-- =========
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } }
        }
    }
}

-- =========
-- Treesitter
-- =========
require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "javascript", "html", "css", "python" },
    highlight = { enable = true },
}

-- =========
-- Statusline
-- =========
require("lualine").setup {
  options = {
    theme = "tokyonight",
    section_separators = "",
    component_separators = ""
  }
}

-- =========
-- Autocomplete
-- =========
local cmp = require("cmp")
cmp.setup {
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  })
}
