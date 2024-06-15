{

  description = "My desktop configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = { #changed to stable because of lsp breakage, unsure if it should stay so
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    eclipse-kerml.url = "github:NixOS/nixpkgs/e89cf1c932006531f454de7d652163a9a5c86668";
  };

  outputs = {self, nixpkgs, nixpkgs-stable, home-manager, nixvim, eclipse-kerml, ...}:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
      kerml-pkgs = eclipse-kerml.legacyPackages.${system};
    in
    {
      nixosConfigurations.nixos = lib.nixosSystem {
        inherit system;
        modules = [./configuration.nix];
        specialArgs = {
          inherit pkgs-stable;
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
