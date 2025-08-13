-- lua/keymaps.lua (acrescentos)
local map = vim.keymap.set
vim.g.mapleader = " "

-- Format (none-ls / LSP)
map({ "n", "v" }, "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format buffer" })

-- Toggle line comment
map("n", "gcc", function() require("Comment.api").toggle.linewise.current() end, { desc = "Toggle comment line" })
map("v", "gc", function()
  local api = require("Comment.api")
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  api.toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment selection" })
