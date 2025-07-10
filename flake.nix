{
  description = "Personal NixOS and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # with imports `{ self, ... }@inputs: `
  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      kernelpanic = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/kernelpanic/default.nix
          ./hosts/kernelpanic/hardware.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.burdz = import ./home/profiles/burdz.nix;
          }
        ];
      };
    };

    homeConfigurations = {
      "burdz" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/profiles/burdz.nix ];
      };
    };
  };
}
