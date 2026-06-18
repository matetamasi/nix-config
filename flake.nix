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

    mangowc = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    angrr = {
      url = "github:linyinfeng/angrr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
          nom-build = pkgs.writeShellScriptBin "n" ''
            case "$1" in
              b) action="build" ;;
              s) action="switch" ;;
              t) action="test" ;;
              r) action="boot" ;;
              *) echo "Unknown command: $1"; exit 1 ;;
            esac
            shift

            if [ "$action" = "build" ]; then
              nixos-rebuild "$action" --flake .#nixos --log-format internal-json --option eval-cache false "$@" |& nom --json
            else
              sudo -v
              sudo nixos-rebuild "$action" --flake .#nixos --log-format internal-json --option eval-cache false "$@" |& nom --json
            fi
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
              alejandra
            ];
          };

        formatter = pkgs.alejandra;
      };
    };
}
