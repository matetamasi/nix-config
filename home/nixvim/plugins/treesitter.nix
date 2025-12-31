{
  programs.nixvim.plugins.treesitter = {
    enable = true;
    folding.enable = true;

    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
  };
}
