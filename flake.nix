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

    eclipse-kerml.url = "github:NixOS/nixpkgs/e89cf1c932006531f454de7d652163a9a5c86668";
  };

  outputs = {self, nixpkgs, home-manager, nixvim, eclipse-kerml, ...}:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      kerml-pkgs = eclipse-kerml.legacyPackages.${system};
    in
    {
      nixosConfigurations.nixos = lib.nixosSystem {
        inherit system;
        modules = [./configuration.nix];
        specialArgs = {
        };
      };

      homeConfigurations.matetamasi = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home.nix];
        extraSpecialArgs = {
          inherit nixvim;
        };
      };

      devShells."${system}".kerml =
      kerml-pkgs.mkShell {
        buildInputs =
        let
          ec = kerml-pkgs.eclipses.eclipse-dsl.overrideAttrs (finalAttrs: previousAttrs: {
            jdk = kerml-pkgs.jdk17;
          });
        in
        with kerml-pkgs;
        [
          dconf
          gtk2
          gtk3
          gtk4
          maven
          gradle
          graphviz
        ] ++ [ec];
      };
    };

}
