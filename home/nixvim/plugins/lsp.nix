{pkgs-stable, ...}:

{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers = {
        nil-ls.enable = true;
        bashls.enable = true;
        clangd.enable = true;
        csharp-ls.enable = true;
        #jsonls.enable = true;
        kotlin-language-server.enable = true;
        pyright.enable = true;
        typst-lsp = {
          enable = true;
          package = pkgs-stable.typst-lsp;
        };
        #rust-analyzer = {
          #enable = true;
          #installCargo = true;
          #installRustc = true;
        #};
      };
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
        action.__raw = "vim.lsp.buf.format";
        key = "<leader>f";
        options.silent = true;
        options.expr = true;
        options.desc = "LSP: [F]ormat";
        mode = ["n"];
      }

    ];
  };
}
