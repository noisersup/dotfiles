{
  description = "NixOS dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-govim.url = "github:NixOS/nixpkgs?rev=aaa77bb67d8d96427e963107f4ddc50b7bb1d272";
    nix.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
  };

  outputs = { self, nixpkgs, nixpkgs-govim, home-manager, nixos-hardware, ... }:
    let
      system = "x86_64-linux";

      pkgs-govim = import nixpkgs-govim {
        inherit system;
        config = { allowUnfree = true; };
      };

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;
    in
    {
      homeConfigurations = {
        "user@nixpc" = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "user";
          homeDirectory = "/home/user";
          configuration = {
            imports = [
              ./users/user/home.nix
              ./modules/home/minecraft/minecraft.nix
            ];
          };
        };
        "user@nix250" = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "user";
          homeDirectory = "/home/user";
          configuration = {
            services.picom.enable = true;
            services.picom.vSync = true;
            imports = [
              ./users/user/home.nix
            ];
          };
        };
      };
      nixosConfigurations = {
        nixpc = lib.nixosSystem {
          specialArgs = { inherit pkgs-govim; };
          inherit system pkgs;

          modules = [
            ./hosts/configuration.nix
            ./modules/nixpc/hardware-configuration.nix
            ./modules/nixpc/default.nix
            ./modules/minikube/default.nix
            ./modules/games
            ./modules/vm
            ./modules/animated-picom
          ];
        };
        nix250 = lib.nixosSystem {
          specialArgs = { inherit pkgs-govim; };
          inherit system;

          modules = [
            ./hosts/configuration.nix
            ./modules/laptop/hardware-configuration.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-x250
            ./modules/laptop/default.nix
            ./modules/animated-picom
          ];
        };
      };

    };
}
