{pkgs, ...}:

{
  imports = [
    ./plugins
    ./keymaps.nix
  ];
  programs.nixvim = {
      enable = true;
      opts = {
        number = true;
        relativenumber = true;
        cursorline = true;
        autoindent = true;
        breakindent = true;
        scrolloff = 6;
        sidescrolloff = 8;
        foldlevel = 3;
        foldminlines = 3;
        foldmethod = "expr";
        foldexpr = "nvim_treesitter#foldexpr()";
        virtualedit = "block";
        autochdir = true;
        ignorecase = true;
        smartcase = true;
        shell = "zsh";
        shiftround = true;
        shiftwidth = 4;
        smarttab = true;
        softtabstop = 4;
        tabstop = 4;
        expandtab = true;
        termguicolors = true;
      };
    filetype = {
        pattern = { __raw = ''{
            ['*.typ'] = 'typst'
            }
        '';
        };
    };
    autoCmd = [
      {
        # Set indent width to 2 spaces in some filetypes
        command = "setlocal shiftwidth=2 tabstop=2 softtabstop=2";
        pattern = [
          "*.typ"
          "*.nix"
        ];
        event = "BufEnter";
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
}
