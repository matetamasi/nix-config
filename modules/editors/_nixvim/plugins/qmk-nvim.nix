{pkgs, ...}: {
  programs.nixvim = {
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
  };
}
