-- lua/plugins.lua
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
  -- Tema base
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },

  -- File manager
  { "stevearc/oil.nvim", opts = {}, dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Telescope
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = function() return vim.fn.executable("make") == 1 end },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Statusline
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- LSP & Mason
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim", dependencies = { "williamboman/mason.nvim" } },
  { "neovim/nvim-lspconfig" },

  -- Autocomplete
  { "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    }
  },

  -- GitSigns (gutter git)
  { "lewis6991/gitsigns.nvim", opts = {
      signs = {
        add = {text = "▎"}, change = {text = "▎"}, delete = {text = "▁"},
        topdelete = {text = "▔"}, changedelete = {text = "▎"},
      },
      current_line_blame = true,
      current_line_blame_opts = { delay = 400 },
    }
  },

  -- Comment.nvim (gc, gcc, etc.)
  { "numToStr/Comment.nvim", opts = {} },

  -- none-ls (format/lint) + mason-bridge
  { "nvimtools/none-ls.nvim" },
  { "jay-babu/mason-null-ls.nvim",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "prettierd",     -- JS/TS/JSON/MD formatter
          "eslint_d",      -- JS/TS linter
          "black",         -- Python formatter
          "flake8",        -- Python linter (opcional)
          "stylua",        -- Lua formatter
        },
        automatic_installation = true,
      })
    end
  },

  -- Seamless tmux navigation
  { "christoomey/vim-tmux-navigator" },
})

-- lualine (tema neon-ish)
require("lualine").setup({
  options = { theme = "tokyonight", section_separators = "", component_separators = "" }
})

-- telescope fzf
pcall(require("telescope").load_extension, "fzf")

-- gitsigns & comment são configurados via opts acima
