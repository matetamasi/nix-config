{

  description = "My desktop configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, nixvim, ...}:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.nixos = lib.nixosSystem {
        inherit system;
        modules = [./configuration.nix];
      };

      homeConfigurations.matetamasi = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home.nix];
        extraSpecialArgs = {
          inherit nixvim;
        };
      };
    };

}
