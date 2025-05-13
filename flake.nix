{
  description = "My desktop configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

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

    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    impermanence.url = "github:nix-community/impermanence";

    eclipse-kerml.url = "github:NixOS/nixpkgs/e89cf1c932006531f454de7d652163a9a5c86668";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixos-hardware,
    disko,
    nixos-cosmic,
    home-manager,
    nixvim,
    plasma-manager,
    impermanence,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    kerml-pkgs = inputs.eclipse-kerml.legacyPackages.${system};
    wezterm-pkg = inputs.wezterm.packages.${system}.default;
    zen-browser-pkg = inputs.zen-browser.packages."${system}".beta;
  in {
    nixosConfigurations.nixos = lib.nixosSystem {
      inherit system;
      modules = [
        nixos-hardware.nixosModules.framework-16-7040-amd

        disko.nixosModules.default
	      (import ./disko.nix {device = "/dev/nvme1n1";})

        home-manager.nixosModules.home-manager {
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
            home-manager.users.matetamasi = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit nixvim;
              inherit wezterm-pkg;
              inherit zen-browser-pkg;
              inherit pkgs-stable;
            };
        }
        impermanence.nixosModules.impermanence

        {
          nix.settings = {
            substituters = [ "https://cosmic.cachix.org/" ];
            trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
          };
        }
        nixos-cosmic.nixosModules.default

        ./configuration.nix
      ];
      specialArgs = {
        inherit pkgs-stable;
      };
    };

    devShells."${system}" = {
      default = pkgs.mkShell {
        NIX_CONFIG = "experimental-features = nix-command flakes";
        packages = with pkgs; [
          nom
        ];
      };
      kerml = kerml-pkgs.mkShell {
        buildInputs = let
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
            ]
            ++ [ec];
      };
      kerml-new = pkgs-stable.mkShell {
        buildInputs = let
          ec = pkgs-stable.eclipses.eclipse-dsl.overrideAttrs (finalAttrs: previousAttrs: {
            jdk = pkgs-stable.jdk17;
          });
        in
          with pkgs-stable;
            [
              dconf
              gtk2
              gtk3
              gtk4
              maven
              gradle
              graphviz
            ]
            ++ [ec];
      };
    };

    formatter.${system} = pkgs.alejandra;
  };
}
