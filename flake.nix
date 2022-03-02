{
  description = "NixOS dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;
  in {
      homeManagerConfigurations = {
          user = home-manager.lib.homeManagerConfiguration {
            inherit system pkgs;
            username = "user";
            homeDirectory = "/home/user";
            configuration = {
                imports = [
                    ./users/user/home.nix
                ];
            };
          };
      };
    nixosConfigurations = {
      nixpc = lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/configuration.nix
          ./modules/nixpc/default.nix
          ./modules/games
        ];
      };
      nix250 = lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/configuration.nix
        ];
      };
    };

  };
}
