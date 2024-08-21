{ config, pkgs, nixvim, ... }:

{
  imports = [
    nixvim.homeManagerModules.nixvim
    ./home/nixvim/nixvim.nix
    #./home/herbstluftwm.nix
  ];
  home.username = "matetamasi";
  home.homeDirectory = "/home/matetamasi";

  programs = {

  home-manager.enable = true;

  zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  starship = {
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
      
  
  wezterm = {
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

  zsh = {
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
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    monaspace
    poppins
    masterpdfeditor4
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
    sc-controller
    prismlauncher #Minecraft launcher
    protonup-qt
    freerdp
    remmina
    plantuml
    staruml
    piper
    pavucontrol
    qmk
    qmk_hid
    # shell scripts
    #(pkgs.writeShellScriptBin "my-hello" ''
    #  echo "Hello, ${config.home.username}!"
    #'')


      firefox
      discord
      signal-desktop
      keepass
      maestral
      caprine-bin
      androidStudioPackages.beta
      zoxide
      xclip
      sqlcmd
      gitkraken
      ungoogled-chromium
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


  home.stateVersion = "23.11";
}
