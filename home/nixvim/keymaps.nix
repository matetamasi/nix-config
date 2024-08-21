{
  programs.nixvim.keymaps = [
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
  ];
}
