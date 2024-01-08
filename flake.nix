{
  description = "My systems";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixvim, ... }:

    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        # Explicitly allow certain unfree software
        config = {
          allowUnfreePredicate = pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [ "obsidian" ];

          permittedInsecurePackages = [ "electron-25.9.0" ];
        };
      };
    in {

      nixosConfigurations = {
        nixbox = lib.nixosSystem {
          inherit system;
          modules = [ ./system/machines/vm-nixbox/configuration.nix ];
        };

        nixtop = lib.nixosSystem {
          inherit system;
          modules = [ ./system/machines/nixtop/configuration.nix ];
        };
      };

      homeConfigurations = {
        evertras-vm = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules =
            [ nixvim.homeManagerModules.nixvim ./home/users/evertras-vm.nix ];
        };

        evertras-nixtop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            nixvim.homeManagerModules.nixvim
            ./home/users/evertras-nixtop.nix
          ];
        };

        work = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ nixvim.homeManagerModules.nixvim ./home/users/work.nix ];
        };
      };
    };
}
