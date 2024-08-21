{pkgs, ...}:

{
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
    plugins = {
      lsp = {
        enable = true;
        servers = {
          nil-ls.enable = true;
          bashls.enable = true;
          clangd.enable = true;
          csharp-ls.enable = true;
          jsonls.enable = true;
          kotlin-language-server.enable = true;
          pyright.enable = true;
          typst-lsp.enable = true;
          #rust-analyzer = {
            #enable = true;
            #installCargo = true;
            #installRustc = true;
          #};
        };
      };

      nvim-jdtls = {
        enable = true;
        data = "/home/matetamasi/.cache/jdtls/workspace";
        configuration = "/home/matetamasi/.cache/jdtls/config";
        rootDir = { __raw = "require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})"; };
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

    extraPlugins = [
      pkgs.vimPlugins.qmk-nvim #nixvim-managed qmk plugin fails to build
    ];
    extraConfigLua = ''

    ---@type qmk.UserConfig
    local conf = {
        name = 'LAYOUT_preonic_1x2uC',
        layout = {
          'x x x x x x x x x x x x',
          'x x x x x x x x x x x x',
          'x x x x x x x x x x x x',
          'x x x x x x x x x x x x',
          'x x x x x x^x x x x x x'
        }
    }
    require('qmk').setup(conf)
    '';

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
}
