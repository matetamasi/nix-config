{
  programs.nixvim.plugins.cmp = {
    enable = true;
    settings.sources = [
      {name = "nvim_lsp";}
      {name = "path";}
      {name = "luasnip";}
    ];
    settings.snippet.expand = ''
      function(args)
          require('luasnip').lsp_expand(args.body)
      end
    '';
    settings.mapping = {
      "<CR>" = "cmp.mapping.confirm({ select = true })";
      "<C-Space>" = "cmp.mapping.complete()";
      "<Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end, {'i', 's'})";
      "<Down>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end, {'i', 's'})";
      "<S-Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end, {'i', 's'})";
      "<Up>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end, {'i', 's'})";
    };
  };
}
