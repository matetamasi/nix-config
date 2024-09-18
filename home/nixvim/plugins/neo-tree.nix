{
  programs.nixvim = {
    plugins.neo-tree.enable = true;
    keymaps = [
      #open/close tree
      {
        action = "<cmd>Neotree toggle<CR>";
        key = "<leader>t";
        options.silent = true;
        mode = ["n" "v"];
      }
    ];
  };
}
