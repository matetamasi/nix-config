{
  description = "My desktop configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    systems.url = "github:nix-systems/default";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    impermanence.url = "github:nix-community/impermanence";
    import-tree.url = "github:vic/import-tree";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nixpkgs-stable,
    nixos-hardware,
    disko,
    agenix,
    home-manager,
    nixvim,
    plasma-manager,
    impermanence,
    import-tree,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    zen-browser-pkg = inputs.zen-browser.packages."${system}".beta;
    agenix-pkgs = agenix.packages."${system}";
  in {
    nixosConfigurations.nixos = lib.nixosSystem {
      inherit system;
      modules = [
        nixos-hardware.nixosModules.framework-16-7040-amd
        agenix.nixosModules.default
        disko.nixosModules.default
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence

        (import-tree ./modules)
      ];
      specialArgs = {
        inherit pkgs-stable;
        inherit agenix-pkgs;
        inherit nixvim;
        inherit zen-browser-pkg;
        inherit plasma-manager;
      };
    };

    devShells.${system}.default = let
      nom-build = pkgs.writeShellScriptBin "nomb" ''
        sudo nixos-rebuild switch --flake .#nixos --log-format internal-json -v |& nom --json
      '';
    in
      pkgs.mkShell {
        NIX_CONFIG = "experimental-features = nix-command flakes";
        packages = with pkgs; [
          nix-output-monitor
          expect
          nom-build
          statix
        ];
      };

    formatter.${system} = pkgs.alejandra;
  };
}
