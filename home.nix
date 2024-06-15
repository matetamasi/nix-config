{ config, pkgs, nixvim, ... }:

{
  imports = [
    nixvim.homeManagerModules.nixvim
  ];
  home.username = "matetamasi";
  home.homeDirectory = "/home/matetamasi";

  programs.nixvim = {
    enable = true;
    opts = {
      number = true;
      relativenumber = true;
      cursorline = true;
      autoindent = true;
      scrolloff = 6;
      foldlevel = 3;
      autochdir = true;
      foldminlines = 3;
      ignorecase = true;
      shell = "zsh";
      shiftround = true;
      shiftwidth = 4;
      smarttab = true;
      softtabstop = 4;
      tabstop = 4;
      expandtab = true;
    };
    plugins = {
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          bashls.enable = false; #TODO: change to true when fixed
          csharp-ls.enable = true;
          jsonls.enable = true;
          kotlin-language-server.enable = true;
          pyright.enable = true;
          typst-lsp.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
        };
      };
      nvim-jdtls = {
        enable = true;
        data = "/home/matetamasi/.cache/jdtls/workspace";
        configuration = "/home/matetamasi/.cache/jdtls/config";
      };

      cmp = {
        enable = true;
        settings.sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "luasnip";}
        ];
        settings.snippet.expand = ''
            function(args)
                require('luasnip').lsp_expand(args.body)
            end
        '';
        settings.mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-Space>" = "cmp.mapping.complete()";
          "<Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end, {'i', 's'})";
          "<Down>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end, {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end, {'i', 's'})";
          "<Up>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end, {'i', 's'})";
        };
      };
      luasnip.enable = true;
      cmp_luasnip.enable = true;
      treesitter = {
        enable = true;
        folding = true;
        indent = true;
      };
      neo-tree = {
        enable = true;
      };
      nvim-autopairs.enable = true;
      surround.enable = true;
      rainbow-delimiters.enable = true;
      nvim-colorizer = {
        enable = true;
        userDefaultOptions = {
          RGB = true;
          RRGGBB = true;
          RRGGBBAA = true;
          names = true;
          mode = "background";
        };
      };
      # qmk = {
      #   enable = true;
      #   settings.comment_preview.position = "top";
      # };
    };

    keymaps = [
    #move between windows
      {
        action = "<C-w>h";
        key = "<A-h>";
        options.silent = true;
      }
      {
        action = "<C-w>j";
        key = "<A-j>";
        options.silent = true;
      }
      {
        action = "<C-w>k";
        key = "<A-k>";
        options.silent = true;
      }
      {
        action = "<C-w>l";
        key = "<A-l>";
        options.silent = true;
      }
    #move windows
      {
        action = "<C-w>H";
        key = "<C-A-h>";
        options.silent = true;
      }
      {
        action = "<C-w>J";
        key = "<C-A-j>";
        options.silent = true;
      }
      {
        action = "<C-w>K";
        key = "<C-A-k>";
        options.silent = true;
      }
      {
        action = "<C-w>L";
        key = "<C-A-l>";
        options.silent = true;
      }
      #move selected lines
      {
        action = "xkP`[V`]";
        key = "<A-Up>";
        options.silent = true;
        mode = ["v"];
      }
      {
        action = "xp`[V`]";
        key = "<C-A-Down>";
        options.silent = true;
        mode = ["v"];
      }
      #open/close tree
      {
        action = "<cmd>Neotree toggle<CR>";
        key = "<Space>t";
        options.silent = true;
        mode = ["n" "v"];
      }
    ];

    #colorschemes.oxocarbon.enable = true;
    #colorschemes.rose-pine.enable = true;
    colorschemes.base16 = {
      enable = true;
      colorscheme = "chalk";
    };
    colorschemes.kanagawa = {
      enable = false;
      settings = {
        theme = "wave";
        background.dark = "wave";
        keywordStyle = {
          italic = false;
          bold = true;
        };
      };
    };
  };

  xsession.windowManager.herbstluftwm = {
    enable = true;
    
    settings = {
      default_frame_layout = 2;
      frame_gap = 10;
      window_border_width = 2;
      window_gap = -2; # Tiling window border overlap
      window_border_inner_width = 0; # Don't touch
      frame_padding = 0; # Don't touch
      frame_border_inner_width = 0; # Don't touch
      frame_border_width = 2; # Outside frame
      frame_transparent_width = 5; # If below is true how much frame is left
      frame_bg_transparent = true;
      always_show_frame = false; # Display all frames or only focused/used
      frame_active_opacity = 50;
      frame_normal_opacity = 50;
      smart_frame_surroundings = true; # Last frame that is left loses border
      smart_window_surroundings = true; # Last window that is left loses border
      snap_distance = 20;
      snap_gap = 0;
      raise_on_focus = true;
      raise_on_click = true;
      focus_follows_mouse = false;
      focus_stealing_prevention = false;
      update_dragged_clients = 1;

      frame_border_active_color = "#ebdbb2";
      frame_bg_active_color = "#ebdbb2";
      window_border_active_color ="#ebdbb2";
      window_border_urgent_color = "#b16286";
      frame_border_inner_color = "black";
      window_border_inner_color = "black";
      window_border_normal_color = "#0A0A0A";
      frame_border_normal_color = "#0F0F0F";
      frame_bg_normal_color = "#0F0F0F";

      tree_style = "'╾│ ├└╼─┐'";

      auto_detect_monitors = true;
    };

    keybinds = {
      # Herbstluftwm control
      Mod4-Control-q = "quit";
      Mod4-Control-r = "reload";
      Mod4-Control-x = "spawn systemctl suspend";
      
      # Window Focusing
      Mod4-Left = "focus left";
      Mod4-Down = "focus down";
      Mod4-Up = "focus up";
      Mod4-Right = "focus right";
      Mod4-h = "focus left";
      Mod4-j = "focus down";
      Mod4-k = "focus up";
      Mod4-l = "focus right";
      Mod4-u = "jumpto urgent";

      # Move between tags
      Mod4-1 = "use_index 0";
      Mod4-Shift-1 = "move_index 0";
      Mod4-2 = "use_index 1";
      Mod4-Shift-2 = "move_index 1";
      Mod4-3 = "use_index 2";
      Mod4-Shift-3 = "move_index 2";
      Mod4-4 = "use_index 3";
      Mod4-Shift-4 = "move_index 3";
      Mod4-5 = "use_index 4";
      Mod4-Shift-5 = "move_index 4";

      # switch between layered windows in the same frame
      Mod4-Tab = "cycle";
      
      # Window actions
      Mod4-q = "close";
      Mod4-Shift-Left = "shift left";
      Mod4-Shift-Down = "shift down";
      Mod4-Shift-Up = "shift up";
      Mod4-Shift-Right = "shift right";
      Mod4-Shift-h = "shift left";
      Mod4-Shift-j = "shift down";
      Mod4-Shift-k = "shift up";
      Mod4-Shift-l = "shift right";
      Mod4-f = "fullscreen toggle";
      Mod4-y = "set_attr clients.focus.floating toggle";
      Mod4-p = "pseudotile toggle";
      
      # Frame operations
      Mod4-s = "chain , split auto , cycle_frame 1";
      Mod4-c = "remove";
      Mod4-Alt-Left = "chain , split left 0.5 , focus -e left";
      Mod4-Alt-Down = "chain , split bottom 0.5 , focus -e down";
      Mod4-Alt-Up = "chain , split top 0.5 , focus -e up";
      Mod4-Alt-Right = "chain , split right 0.5 , focus -e right";
      Mod4-Alt-h = "chain , split left 0.5 , focus -e left";
      Mod4-Alt-j = "chain , split bottom 0.5 , focus -e down";
      Mod4-Alt-k = "chain , split top 0.5 , focus -e up";
      Mod4-Alt-l = "chain , split right 0.5 , focus -e right";
      Mod4-b = "chain , lock , rotate , unlock";
      Mod4-n = "chain , lock , rotate , rotate , rotate , unlock";
      
      # Resizing frames
      Mod4-Control-Left = "resize left +0.05";
      Mod4-Control-Down = "resize down +0.05";
      Mod4-Control-Up = "resize up +0.05";
      Mod4-Control-Right = "resize right +0.05";
      Mod4-Control-h = "resize left +0.05";
      Mod4-Control-j = "resize down +0.05";
      Mod4-Control-k = "resize up +0.05";
      Mod4-Control-l = "resize right +0.05";
      
      Mod4-period = "cycle_value frame_gap 0 5 10 15 20 25 30 35 40";
      Mod4-comma = "cycle_value frame_gap 40 35 30 25 20 15 10 5 0";
      
      Mod4-Control-f = "floating toggle";
      Mod4-Shift-f = "set_attr clients.focus.floating toggle";
      
      # Application launching
      Mod4-Return = "spawn wezterm"; #TODO: use $TERM instead
      Mod4-r = "spawn .config/polybar/scripts/launcher.sh";
      Mod4-Control-p = "spawn .config/polybar/scripts/powermenu.sh";
      

      #screenshot (using scrot)
      #mkdir -p $HOME/screenshots
      Print = "spawn scrot 'Pictures/Screenshots/%Y-%m-%d_%H-%M-%S_$wx$h.png'";
      Mod4-Print = "spawn scrot 'Pictures/Screenshots/%Y-%m-%d_%H-%M-%S_$wx$h.png' --focused";
      Ctrl-Print = "spawn scrot 'Pictures/Screenshots/%Y-%m-%d_%H-%M-%S_$wx$h.png' --select --freeze";
      Shift-Print = "spawn scrot -e 'xclip -selection clipboard -t image/png -i $f && rm $f'";
      Ctrl-Shift-Print = "spawn scrot --select --freeze -e 'xclip -selection clipboard -t image/png -i $f && rm $f'";
      
      # Media keys
      XF86AudioRaiseVolume = "spawn pamixer -i 5";
      XF86AudioLowerVolume = "spawn pamixer -d 5";
      XF86AudioMute = "spawn pamixer -t";
      XF86MonBrightnessUp = "spawn xbacklight -inc 5";
      XF86MonBrightnessDown = "spawn xbacklight -dec 5";
      
      XF86AudioPlay = "spawn playerctl play-pause";
      XF86AudioPrev = "spawn playerctl previous";
      XF86AudioNext = "spawn playerctl next";
    };

    mousebinds = {
      Mod4-Button1 = "move";
      Mod4-Button2 = "zoom";
      Mod4-Button3 = "resize";
    };

    tags = [
    "1"
    "2"
    "3"
    "4"
    "5"
    ];

    extraConfig = ''
      xsetroot -solid '#9900dd'
      set_layout max
      detect_monitors

      # Set key chord for launching apps
      # Create the array of keys
      app_keys=(f s)
      # Build the command to unbind the keys
      unbind=( )
      for k in "''${app_keys[@]}" Escape ; do
      	unbind+=( , keyunbind "$k" )
      done
      
      # Set apps to launch
      herbstclient keybind Mod4-a chain \
      	'->' keybind "''${app_keys[0]}" chain "''${unbind[@]}" , spawn firefox \
      	'->' keybind "''${app_keys[1]}" chain "''${unbind[@]}" , spawn steam \
      	'->' keybind Escape chain "''${unbind[@]}"
    '';
    
    rules = [
      "focus=on" # Normally focus new clients
      "windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' floating=on"
      "windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on"
      "windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off"
      "windowtype~'_NET_WM_WINDOW_TYPE_(FULLSCREEN|FS)' fullscreen=on"
      "instance='gcolor2' floating=on"
      "instance='feh' floating=on"
      "instance='nitrogen' floating=on"
      "class='Pidgin' floating=on"
      "class='Gbdfed' floating=on"
      "title='Loading Tixati...' manage=off"
    ];
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      ignoreAllDups = true;
      ignoreSpace = false;
      save = 100000000;
      size = 1000000000;
    };
    autosuggestion.enable = true;
    enableCompletion = true;
    historySubstringSearch.enable = true;

    syntaxHighlighting.enable = true;
    initExtraFirst = ''
        zstyle ':completion:*' completer _expand _complete _ignored _match
        zstyle ':completion:*' completions '_expand'
        zstyle ':completion:*' expand prefix
        zstyle ':completion:*' glob '_expand'
        zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*'
        zstyle ':completion:*' max-errors 1
        zstyle ':completion:*' menu select=2
        zstyle ':completion:*' original false
        zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s%1
        zstyle ':completion:*' group-name ""
        
        setopt ALWAYS_LAST_PROMPT
        setopt NO_BEEP
        setopt COMPLETE_IN_WORD
        setopt CHASE_LINKS
        setopt GLOB_DOTS
        # Always moves cursor to end after completion
        setopt ALWAYS_TO_END
        # Set, when the completion is ambiguous you get a list without having to type ^D
        setopt AUTO_LIST
        # If on - the string on the command line exactly matches one of the possible completions, it is accepted, even if there is another completion (i.e. that string with something else added)
        setopt NO_REC_EXACT
        # If on - one completion is always inserted completely, then when you hit TAB it changes to the next, and so on until you get back to where you started
        setopt NO_MENU_COMPLETE
        # This is modified so that nothing is listed if there is an unambiguous prefix or suffix to be inserted
        #setopt LIST_AMBIGUOUS
        # If on - only get the menu behaviour when you hit TAB again on the ambiguous completion
        setopt AUTO_MENU
        
        # Expand aliases
        setopt ALIASES
        
        zstyle ':completion:*' rehash true

        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        bindkey "''${key[Up]}" history-substring-search-up
        bindkey "''${key[Down]}" history-substring-search-down
    zle -N history-substring-search-up
    zle -N history-substring-search-down

    zmodload zsh/complist
        bindkey -M menuselect '^[[Z' reverse-menu-complete
      '';
    oh-my-zsh = {
      plugins = [
        "zsh-syntax-highlighting"
    "zsh-history-substring-search"
      ];
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {

      format = "$username$hostname$git_branch$git_status$fill$cmd_duration$time$line_break$directory$character";
      
      add_newline = true;
      
      username = {
      show_always = true;
      style_user = "fg:#73a5b2";
      style_root = "fg:#d03000";
      format = "\\[[$user]($style)";
      };

      fill = {
      symbol="-";
      };
      
      hostname = {
      ssh_only=false;
      style = "fg:default";
      format="@[$hostname]($style)\\]";
      };

      directory = {
      style = "fg:red";
      repo_root_style="fg:cyan";
      format = "[$path]($style) ";
      truncation_length = 8;
      truncation_symbol = "…/";
      truncate_to_repo=false;
      };
      
      git_branch = {
      style = "fg:#fabd2f";
      format = "\\[[[$symbol$branch](fg:#fabd2f)]($style)\\] ";
      };
      
      git_status = {
      style = "fg:#fabd2f";
      format = "\\[[[($all_status$ahead_behind)](fg:#fabd2f)]($style)\\] ";
      };
      
      character = {
      success_symbol = "[>>>](fg:green bold)";
      error_symbol = "[>>>](fg:red bold)";
      vicmd_symbol = "[<](fg:#98971a bold)";
      };
      
      cmd_duration = {
      style="fg:green";
      min_time = 0;
      format = "\\[[$duration]($style)\\]";
      };
      
      time = {
      disabled = false;
      style="fg:bright-purple";
      time_format = "%R";
      format = "\\[[$time]($style)\\] ";
      };
    };
  };
      
  
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local config = {}
      local act = wezterm.action
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

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    monaspace
    dotnet-sdk_8
    postman
    maven
    gsettings-desktop-schemas
    libreoffice-qt
    ncspot
    gimp
    obs-studio
    haruna
    zathura
    filelight
    typst
    wl-clipboard
    spotify
    steam
    atlauncher #Minecraft launcher
    protonup-qt
    freerdp
    remmina
    plantuml
    staruml
    piper
    pavucontrol
    qmk
    # # overrides
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # shell scripts
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  fonts.fontconfig.enable = true;

  #dotfiles
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/zathura/zathurarc".text = ''
      map <C-i> recolor
    '';
  };

  # Environment variables
  home.sessionVariables = {
     EDITOR = "nvim";
     TERM = "wezterm";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
