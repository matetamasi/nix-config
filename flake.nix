{
  description = "My desktop configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      #changed to stable because of lsp breakage, unsure if it should stay so
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    eclipse-kerml.url = "github:NixOS/nixpkgs/e89cf1c932006531f454de7d652163a9a5c86668";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    disko,
    home-manager,
    impermanence,
    nixvim,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    #pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    pkgs-stable = import nixpkgs-stable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    kerml-pkgs = inputs.eclipse-kerml.legacyPackages.${system};
    wezterm-pkg = inputs.wezterm.packages.${system}.default;
  in {
    nixosConfigurations.nixos = lib.nixosSystem {
      inherit system;
      modules = [
        disko.nixosModules.default
	(import ./disko.nix {device = "/dev/nvme1n1";})
        home-manager.nixosModules.home-manager
	{
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.matetamasi = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit nixvim;
              inherit wezterm-pkg;
              inherit pkgs-stable;
            };
        }
        impermanence.nixosModules.impermanence
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
          cowsay
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
    };

    formatter.${system} = pkgs.alejandra;
  };
}
