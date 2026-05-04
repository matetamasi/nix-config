{
  programs.nixvim.plugins.colorizer = {
    enable = true;
    settings.userDefaultOptions = {
      RGB = true;
      RRGGBB = true;
      RRGGBBAA = true;
      names = true;
      # mode = "background";
    };
  };
}
