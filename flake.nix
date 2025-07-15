{
  description = "Personal NixOS and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Use an overriden version for now https://github.com/sst/opencode/issues/462
    opencode.url = "github:sst/opencode/v0.3.9";
    opencode.flake = false;

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # with imports `{ self, ... }@inputs: `
  outputs = { nixpkgs, nixpkgs-unstable, opencode, home-manager, ... }:
  let
    system = "x86_64-linux";

    overlays = [
      (final: prev: {
        codex-cli = prev.callPackage ./home/packages/codex-cli.nix {};
        opencode = prev.callPackage ./home/packages/opencode.nix {
          inherit nixpkgs-unstable;
          opencode-src = opencode;
        };
      })
    ];

    pkgs = import nixpkgs {
      inherit system;
      inherit overlays;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      kernelpanic = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/kernelpanic/default.nix
          ./hosts/kernelpanic/hardware.nix

          { nixpkgs.overlays = overlays; }

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
