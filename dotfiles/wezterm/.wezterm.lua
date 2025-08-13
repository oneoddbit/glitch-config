local wezterm = require "wezterm"
local act = wezterm.action

return {
  -- Tema & fonte
  color_scheme = "Tokyo Night Storm",
  font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" }),
  font_size = 13.0,

  -- Desativar barra de título
  window_decorations = "RESIZE",
  default_prog = {"/bin/zsh","-l","-c",'tmux attach -t main || tmux new -s main'},

  -- Atalhos para navegar splits (ALT+setas)
  keys = {
    { key = "LeftArrow",  mods = "ALT",       action = act.SendKey({ SendKey = { key = "h", mods = "CTRL" } }) },
    { key = "RightArrow", mods = "ALT",       action = act.SendKey({ SendKey = { key = "l", mods = "CTRL" } }) },
    { key = "UpArrow",    mods = "ALT",       action = act.SendKey({ SendKey = { key = "k", mods = "CTRL" } }) },
    { key = "DownArrow",  mods = "ALT",       action = act.SendKey({ SendKey = { key = "j", mods = "CTRL" } }) },

    -- Mover splits (ALT+SHIFT+setas)
    { key = "LeftArrow",  mods = "ALT|SHIFT", action = act.SendKey({ SendKey = { key = "H", mods = "CTRL|SHIFT" } }) },
    { key = "RightArrow", mods = "ALT|SHIFT", action = act.SendKey({ SendKey = { key = "L", mods = "CTRL|SHIFT" } }) },
    { key = "UpArrow",    mods = "ALT|SHIFT", action = act.SendKey({ SendKey = { key = "K", mods = "CTRL|SHIFT" } }) },
    { key = "DownArrow",  mods = "ALT|SHIFT", action = act.SendKey({ SendKey = { key = "J", mods = "CTRL|SHIFT" } }) },
  },

  -- Ao abrir o terminal, ligar-se ou criar sessão 'main'
  default_prog = {"/bin/zsh", "-l", "-c", 'tmux attach -t main || tmux new -s main'},

  -- Margens visuais
  window_padding = {
    left = 2, right = 2, top = 1, bottom = 1,
  },
}
