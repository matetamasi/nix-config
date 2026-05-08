{
  description = "My desktop configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

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

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }: let
    system = "x86_64-linux";
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [system];

      imports = [
        (inputs.import-tree ./modules)
        {
          options.flake.modules = nixpkgs.lib.mkOption {
            type = nixpkgs.lib.types.attrsOf (nixpkgs.lib.types.attrsOf nixpkgs.lib.types.unspecified);
            default = {};
            description = "Dendritic modules";
          };
        }
      ];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        devShells.default = let
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
              nvd
            ];
          };

        formatter = pkgs.alejandra;
      };
    };
}
