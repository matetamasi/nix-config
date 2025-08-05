{pkgs-stable, ...}: {
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        servers = {
          elixirls.enable = true;
          gleam.enable = true;
          #prolog_ls.enable = true;
          nil_ls.enable = true;
          bashls.enable = true;
          clangd.enable = true;
          csharp_ls.enable = true;
          #jsonls.enable = true;
          kotlin_language_server.enable = true;
          pyright.enable = true;
          tinymist.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
            settings.rustfmt.enable = true;
          };
        };
      };

      conform-nvim = {
        enable = true;

        settings = {
          format_on_save = {
            lsp_fallback = "fallback";
            timeout_ms = 2000;
          };
          notify_on_error = true;
          formatters_by_ft = {
            python = ["black"];
            nix = ["alejandra"];
            #TODO: further formatters
          };
        };
      };

      none-ls = {
        enable = true;
        sources.formatting = {
          black.enable = true;
          alejandra.enable = true;
        };
      };

      cmp-nvim-lsp.enable = true;
      lspkind.enable = true;
      lspkind.cmp.enable = true;
      luasnip.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-treesitter.enable = true;
    };
    keymaps = [
      #rename
      {
        action.__raw = "vim.lsp.buf.rename";
        key = "<leader>rn";
        options.silent = true;
        options.expr = true;
        options.desc = "LSP: [R]e[n]ame";
        mode = ["n"];
      }
      #code actions
      {
        action.__raw = "vim.lsp.buf.code_action";
        key = "<leader>ca";
        options.silent = true;
        options.expr = true;
        options.desc = "LSP: [C]ode [A]ction";
        mode = ["n"];
      }
      #goto definition
      {
        action.__raw = "vim.lsp.buf.definition";
        key = "gdd";
        options.silent = true;
        options.expr = true;
        options.desc = "LSP: [G]oto [D]efinition";
        mode = ["n"];
      }
      #goto declaration
      {
        action.__raw = "vim.lsp.buf.declaration";
        key = "gdc";
        options.silent = true;
        options.expr = true;
        options.desc = "LSP: [G]oto [D]e[c]laration";
        mode = ["n"];
      }
      #goto implementation
      {
        action.__raw = "vim.lsp.buf.implementation";
        key = "gdi";
        options.silent = true;
        options.expr = true;
        options.desc = "LSP: [G]oto [D] [I]mplementation";
        mode = ["n"];
      }
      #goto type definition
      {
        action.__raw = "vim.lsp.buf.type_definition";
        key = "gdt";
        options.silent = true;
        options.expr = true;
        options.desc = "LSP: [G]oto [D]efinition of [T]ype";
        mode = ["n"];
      }
      #goto references (requires telescope!)
      {
        action.__raw = "require('telescope.builtin').lsp_references";
        key = "gdr";
        options.silent = true;
        options.expr = true;
        options.desc = "LSP: [G]oto [D] [R]eferences";
        mode = ["n"];
      }

      #hover
      {
        action.__raw = "vim.lsp.buf.hover";
        key = "K";
        options.silent = true;
        options.expr = true;
        options.desc = "LSP: Hover";
        mode = ["n"];
      }
      #signature docs
      {
        action.__raw = "vim.lsp.buf.signature_help";
        key = "<C-k>";
        options.silent = true;
        options.expr = true;
        options.desc = "LSP: Signature docs";
        mode = ["n"];
      }

      #format
      {
        action = "<cmd>lua require('conform').format()<CR>";
        key = "<leader>f";
        options.silent = true;
        options.desc = "LSP: [F]ormat";
        mode = ["n"];
      }

      #next diagnostic
      {
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        key = "<leader>]";
        options.silent = true;
        options.desc = "LSP: Next diagnostic";
        mode = ["n"];
      }

      #previous diagnostic
      {
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        key = "<leader>[";
        options.silent = true;
        options.desc = "LSP: Previous diagnostic";
        mode = ["n"];
      }
    ];
  };
}
