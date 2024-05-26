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
          bashls.enable = true;
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
    protonup-qt
    freerdp
    remmina
    plantuml
    staruml
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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
