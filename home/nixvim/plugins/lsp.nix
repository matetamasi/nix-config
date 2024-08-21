{pkgs-stable, ...}:

{
  programs.nixvim.plugins.lsp = {
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
}
