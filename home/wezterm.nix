{wezterm-pkg, ...}:
{
  programs.wezterm = {
    enable = true;
    package = wezterm-pkg; #required due to https://github.com/wez/wezterm/issues/5990
    enableZshIntegration = true;
    extraConfig = ''
      local config = {}
      local act = wezterm.action
      config.enable_wayland = false
      config.scrollback_lines = 100000
      config.color_scheme = 'Afterglow'
      config.bold_brightens_ansi_colors = "No"
      config.font = wezterm.font_with_fallback {
        {family = 'Monaspace Neon', weight = 'Light'},
        {family = 'JetBrains Mono', weight = 'Medium'},
    'Noto Color Emoji'
      }
      config.font_rules = {
        {
          intensity = 'Bold',
      italic = false,
      font = wezterm.font_with_fallback {
            {family = 'Monaspace Neon', weight = 'Bold'},
            {family = 'JetBrains Mono', weight = 'Bold'},
        'Noto Color Emoji'
      }
    },
        {
          intensity = 'Bold',
      italic = true,
      font = wezterm.font_with_fallback {
            {family = 'Monaspace Radon', weight = 'Bold', italic = true},
            {family = 'JetBrains Mono', weight = 'Bold', italic = true},
        'Noto Color Emoji'
      }
    },
        {
          intensity = 'Half',
      italic = false,
      font = wezterm.font_with_fallback {
            {family = 'Monaspace Neon', weight = 'ExtraLight'},
            {family = 'JetBrains Mono', weight = 'Light'},
        'Noto Color Emoji'
      }
    },
        {
          intensity = 'Half',
      italic = true,
      font = wezterm.font_with_fallback {
            {family = 'Monaspace Radon', weight = 'ExtraLight', italic = true},
            {family = 'JetBrains Mono', weight = 'Light', italic = true},
        'Noto Color Emoji'
      }
    },
        {
      italic = true,
      font = wezterm.font_with_fallback {
            {family = 'Monaspace Radon', weight = 'Light', italic = true},
            {family = 'JetBrains Mono', weight = 'Medium', italic = true},
        'Noto Color Emoji'
      }
    },
      }
      config.harfbuzz_features = {'dlig=1', 'calt=1', 'ss01=1', 'ss02=1', 'ss03=1', 'ss06=1', 'ss07=1', 'ss08=1'}

      config.mouse_bindings = {
        -- Scrolling up while holding CTRL increases the font size
        {
          event = { Down = { streak = 1, button = { WheelUp = 1 } } },
          mods = 'CTRL',
          action = act.IncreaseFontSize,
        },
      
        -- Scrolling down while holding CTRL decreases the font size
        {
          event = { Down = { streak = 1, button = { WheelDown = 1 } } },
          mods = 'CTRL',
          action = act.DecreaseFontSize,
        },
        {
          event = { Down = { streak = 1, button = { WheelUp = 1 } } },
          mods = 'NONE',
          action = act.ScrollByLine(-8),
        },
      
        {
          event = { Down = { streak = 1, button = { WheelDown = 1 } } },
          mods = 'NONE',
          action = act.ScrollByLine(8),
        },
      }

      config.keys = {
        {
          key = 'w',
          mods = 'CTRL',
          action = wezterm.action.CloseCurrentTab { confirm = true },
        },
        {
          key = 't',
          mods = 'CTRL',
          action = act.SpawnTab 'CurrentPaneDomain',
        },

      }

      return config
    '';
  };
}
