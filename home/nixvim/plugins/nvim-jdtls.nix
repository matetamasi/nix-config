{
  programs.nixvim.plugins.nvim-jdtls = {
    enable = true;
    data = "/home/matetamasi/.cache/jdtls/workspace";
    configuration = "/home/matetamasi/.cache/jdtls/config";
    rootDir = {__raw = "require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})";};
  };
}
