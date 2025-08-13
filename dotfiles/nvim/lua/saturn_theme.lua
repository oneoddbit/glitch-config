-- lua/saturn_theme.lua
local M = {}

-- Paleta Saturn (a combinar com starship)
local C = {
  bg0   = "#000014",
  fg0   = "#E5E5E5",
  seg1  = "#8B5CF6",
  seg2  = "#00B3FF",
  seg3  = "#00FFD5",
  ok    = "#22C55E",
  warn  = "#FFDD00",
  err   = "#FF6E6E",
  timec = "#767676",
}

function M.apply()
  -- Base: tokyonight
  vim.cmd.colorscheme("tokyonight")

  local set = function(group, opts) vim.api.nvim_set_hl(0, group, opts) end

  -- Fundo e texto
  set("Normal",      { fg = C.fg0, bg = C.bg0 })
  set("NormalFloat", { fg = C.fg0, bg = C.bg0 })
  set("FloatBorder", { fg = C.seg2, bg = C.bg0 })
  set("CursorLine",  { bg = "#040420" })
  set("CursorLineNr",{ fg = C.seg3, bold = true })
  set("LineNr",      { fg = C.timec })

  -- Seleções e buscas
  set("Visual",  { bg = "#142244" })
  set("Search",  { fg = C.bg0, bg = C.seg2, bold = true })
  set("IncSearch",{ fg = C.bg0, bg = C.seg3, bold = true })

  -- Diagnósticos
  set("DiagnosticError", { fg = C.err })
  set("DiagnosticWarn",  { fg = C.warn })
  set("DiagnosticInfo",  { fg = C.seg2 })
  set("DiagnosticHint",  { fg = C.seg3 })
  set("DiagnosticUnderlineError", { undercurl = true, sp = C.err })
  set("DiagnosticUnderlineWarn",  { undercurl = true, sp = C.warn })

  -- Git (signs)
  set("DiffAdd",    { fg = C.ok })
  set("DiffChange", { fg = C.seg2 })
  set("DiffDelete", { fg = C.err })
  set("DiffText",   { fg = C.seg3 })

  -- Telescope
  set("TelescopeBorder",       { fg = C.seg2, bg = C.bg0 })
  set("TelescopeTitle",        { fg = C.seg1, bold = true })
  set("TelescopeMatching",     { fg = C.seg3, bold = true })
  set("TelescopeSelection",    { bg = "#101035", bold = true })

  -- Statusline (lualine usa tema, mas deixamos cores chave para plugins que leem HLs)
end

return M
