-- ~/.config/wezterm/wezterm.lua
local wezterm = require("wezterm")
local mux = wezterm.mux

local default_font_size = 8.5
local font_size = default_font_size

local function update_font_size(window)
  local overrides = window:get_config_overrides() or {}

  local is_4k = window:get_dimensions().pixel_width == 3840
  if is_4k then
    font_size = 11
  else
    font_size = default_font_size
  end
  overrides.font_size = font_size
  window:set_config_overrides(overrides)
end

local keys = {
  { key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay }
}

for i = 1, 8 do
  -- F1 through F8 to activate that tab
  table.insert(keys, {
    key = "F" .. tostring(i),
    action = wezterm.action({ ActivateTab = i - 1 }),
  })
end

-- set default dir
local wsl_domains = wezterm.default_wsl_domains()
for _, dom in ipairs(wsl_domains) do
  dom.default_cwd = "~"
end

-- maximize on startup
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})

  window:gui_window():maximize()
  update_font_size(window:gui_window())
end)

wezterm.on('window-resized', function(window)
  update_font_size(window)
end)

return {
  -- ui
  enable_tab_bar = false,
  window_decorations = "RESIZE",
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },

  -- set default dir
  wsl_domains = wsl_domains,
  default_domain = "WSL:Ubuntu",

  keys = keys,
  font = wezterm.font("FiraCode Nerd Font"),
  font_size = font_size,
  color_scheme = "PencilLight",

  -- wsl
  default_prog = { "wsl.exe" },
}
