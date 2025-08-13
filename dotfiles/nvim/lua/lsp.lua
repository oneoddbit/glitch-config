-- lua/lsp.lua
local mason_ok, mason = pcall(require, "mason")
if mason_ok then mason.setup() end

local mlsp_ok, mls = pcall(require, "mason-lspconfig")
if mlsp_ok then
  mls.setup({
    ensure_installed = {
        "lua_ls",         -- Lua
        "tsserver",       -- TypeScript
        "html",           -- HTML
        "cssls",          -- CSS
        "pyright",        -- Python
        "clangd",         -- C/C++
        "gopls",          -- Go
        "rust_analyzer",  -- Rust
        "omnisharp",      -- C#
        "jdtls",          -- Java
    }
  })
end

local lspconfig = require("lspconfig")
local cmp_ok, cmp = pcall(require, "cmp")
local cmp_lsp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")

-- cmp setup
if cmp_ok then
  local luasnip = require("LuaSnip")
  cmp.setup({
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"]      = cmp.mapping.confirm({ select = true }),
      ["<Tab>"]     = cmp.mapping.select_next_item(),
      ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "path" },
      { name = "buffer" },
      { name = "luasnip" },
    }),
  })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
if cmp_lsp_ok then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- On attach keymaps
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "K",  vim.lsp.buf.hover, "Hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>fd", vim.diagnostic.open_float, "Line diagnostics")
  map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
  -- Format atajo
  map({ "n", "v" }, "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
end

local function setup(server, opts)
  opts = opts or {}
  opts.on_attach = on_attach
  opts.capabilities = capabilities
  lspconfig[server].setup(opts)
end

setup("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } } }
})
setup("tsserver")
setup("html")
setup("cssls")
setup("pyright")
setup("clangd")
setup("gopls")
setup("rust_analyzer")
setup("omnisharp")
setup("jdtls")

-- none-ls (formatters/linters)
local null_ok, null_ls = pcall(require, "null-ls")
if null_ok then
  
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions

  null_ls.setup({
    sources = {
      -- Formatters
      formatting.prettierd,
      formatting.black,
      formatting.stylua,

      -- Linters / code actions
      diagnostics.eslint_d,
      code_actions.eslint_d,
      diagnostics.flake8, -- opcional

      -- ===== C / C++ =====
      formatting.clang_format,             -- requer clang-format
      diagnostics.cppcheck,                -- opcional (análise estática)
      -- diagnostics.clang_check,          -- alternativa/extra se preferires

      -- ===== Go =====
      formatting.gofumpt,                  -- formatação (gofumpt > gofmt)
      formatting.goimports_reviser,        -- organiza imports
      diagnostics.golangci_lint,           -- lint all-in-one (rápido)

      -- ===== Rust =====
      formatting.rustfmt,                  -- formatação (usa toolchain)

      -- ===== CSharp =====
      formatting.csharpier,

      -- ===== Java =====
      formatting.google_java_format,
    },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      -- format on save (opcional; comenta se não quiseres)
      if client.supports_method("textDocument/formatting") then
        local grp = vim.api.nvim_create_augroup("SaturnFormat", { clear = false })
        vim.api.nvim_clear_autocmds({ group = grp, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = grp,
          buffer = bufnr,
          callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
        })
      end
    end,
  })
end
