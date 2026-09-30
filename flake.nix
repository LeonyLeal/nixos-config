{
  description = "NixOS Z30N - Hyprland + DMS + Development Workstation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Usado para aplicações específicas que precisam de versão
    # mais recente, como Kitty com suporte a custom shaders.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms.url = "github:AvengeMedia/DankMaterialShell/v1.6.2";

    dank-greeter.url = "github:AvengeMedia/dank-greeter";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    globalprotect-openconnect.url = "github:yuezk/GlobalProtect-openconnect";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    dms,
    dank-greeter,
    nix-index-database,
    sops-nix,
    globalprotect-openconnect,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    pkgsUnstable =
      nixpkgs-unstable.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.alejandra;
    checks.${system} = import ./tests/checks.nix {
      inherit pkgs;
      systemConfig = self.nixosConfigurations.nixos;
    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit
          inputs
          dms
          pkgsUnstable
          ;
      };

      modules = [
        ./configuration.nix

        dank-greeter.nixosModules.default

        sops-nix.nixosModules.sops

        globalprotect-openconnect.nixosModules.default

        home-manager.nixosModules.home-manager

        {
          home-manager = {
            extraSpecialArgs = {inherit pkgsUnstable;};
            useGlobalPkgs =
              true;
            useUserPackages =
              true;
            backupFileExtension = "hm-backup";
            sharedModules = [
              nix-index-database.homeModules.default
            ];
            users.z30n =
              import ./home.nix;
          };
        }
      ];
    };
  };
}
