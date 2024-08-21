{
  programs.nixvim.plugins.nvim-colorizer = {
    enable = true;
    userDefaultOptions = {
      RGB = true;
      RRGGBB = true;
      RRGGBBAA = true;
      names = true;
      mode = "background";
    };
  };
}
