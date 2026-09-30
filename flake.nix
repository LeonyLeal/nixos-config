{
  description = "NixOS Z30N - Hyprland + DMS + Development Workstation";

  inputs = {
    # ==========================================================
    # NIXPKGS
    # ==========================================================

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Usado para aplicações específicas que precisam de versão
    # mais recente, como Kitty com suporte a custom shaders.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ==========================================================
    # HOME MANAGER
    # ==========================================================

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ==========================================================
    # DANK MATERIAL SHELL
    # ==========================================================

    dms.url = "github:AvengeMedia/DankMaterialShell/v1.6.2";

    # ==========================================================
    # DANK GREETER
    # ==========================================================

    dank-greeter.url = "github:AvengeMedia/dank-greeter";

    # ==========================================================
    # NIX INDEX
    # ==========================================================

    nix-index-database = {
      url = "github:nix-community/nix-index-database";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ==========================================================
    # SOPS
    # ==========================================================

    sops-nix = {
      url = "github:Mic92/sops-nix";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ==========================================================
    # GLOBALPROTECT
    # ==========================================================

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

    pkgsUnstable =
      nixpkgs-unstable.legacyPackages.${system};
  in {
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

        # ==================================================
        # DANK GREETER
        # ==================================================

        dank-greeter.nixosModules.default

        # ==================================================
        # SOPS
        # ==================================================

        sops-nix.nixosModules.sops

        # ==================================================
        # GLOBALPROTECT
        # ==================================================

        globalprotect-openconnect.nixosModules.default

        # ==================================================
        # HOME MANAGER
        # ==================================================

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs =
            true;

          home-manager.useUserPackages =
            true;

          home-manager.backupFileExtension = "hm-backup";

          home-manager.sharedModules = [
            nix-index-database.homeModules.default
          ];

          home-manager.users.z30n =
            import ./home.nix;
        }
      ];
    };
  };
}
