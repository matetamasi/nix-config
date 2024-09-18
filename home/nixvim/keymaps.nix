{
  programs.nixvim = {
    globals = {
        mapleader = " ";
        maplocalleader = " ";
    };

    keymaps = [
      #unbind space
      {
        action = "<Nop>";
        key = "<Space>";
        options.silent = true;
        mode = ["n" "v"];
      }
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

      # center cursor on some scroll actions
      {
        action = "<C-u>zz";
        key = "<C-u>";
        options.silent = true;
        mode = ["n"];
      }
      {
        action = "<C-d>zz";
        key = "<C-d>";
        options.silent = true;
        mode = ["n"];
      }
      {
        action = "<C-b>zz";
        key = "<C-b>";
        options.silent = true;
        mode = ["n"];
      }
      {
        action = "<C-f>zz";
        key = "<C-f>";
        options.silent = true;
        mode = ["n"];
      }
      {
        action = "nzvzz";
        key = "n";
        options.silent = true;
        mode = ["n"];
      }
      {
        action = "Nzvzz";
        key = "N";
        options.silent = true;
        mode = ["n"];
      }

      # move up/down per visual lines (when wrapping lines)
      {
        action = "v:count == 0 ? 'gk' : 'k'";
        key = "k";
        options.silent = true;
        options.expr = true;
        mode = ["n"];
      }
      {
        action = "v:count == 0 ? 'gj' : 'j'";
        key = "j";
        options.silent = true;
        options.expr = true;
        mode = ["n"];
      }

      # delete from this word until end of line
      {
        action = "BC";
        key = "<leader>b";
        options.silent = true;
        options.desc = "[B]ullshit (delete until eol)";
        mode = ["n"];
      }
    ];
  };
}
