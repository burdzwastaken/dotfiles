{
  description = "Personal NixOS and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # use an overridden version for now https://github.com/sst/opencode/issues/462
    opencode = {
      url = "github:sst/opencode/v0.3.122";
      flake = false;
    };
  };

  # with imports `{ self, ... }@inputs: `
  outputs = { nixpkgs, nixpkgs-unstable, opencode, home-manager, ... }:
    let
      system = "x86_64-linux";

      overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable {
            system = prev.system;
            config.allowUnfree = true;
          };
          codex-cli = prev.callPackage ./home/packages/codex.nix { };
          opencode = prev.callPackage ./home/packages/opencode.nix {
            unstable = final.unstable;
            opencode-src = opencode;
          };
          libgit2_1_1 = prev.libgit2.overrideAttrs (old: {
            version = "1.1.1";
            src = prev.fetchFromGitHub {
              owner = "libgit2";
              repo = "libgit2";
              rev = "v1.1.1";
              sha256 = "sha256-SxceIxT0aeiiiZCeSIe6EOa+MyVpQVaiv/ZZn6fkwIc=";
            };
            patches = [ ];
            doCheck = false;
          });
          # keep for future bump?
          # libgit2_1_3 = prev.libgit2.overrideAttrs (old: {
          #   version = "1.3.0";
          #   src = prev.fetchFromGitHub {
          #     owner = "libgit2";
          #     repo = "libgit2";
          #     rev = "v1.3.0";
          #     sha256 = "sha256-7atNkOBzX+nU1gtFQEaE+EF1L+eex+Ajhq2ocoJY920=";
          #   };
          #   patches = [ ];
          #   doCheck = false;
          # });
        })
      ];

      pkgs = import nixpkgs {
        inherit system;
        inherit overlays;
        config.allowUnfree = true;
      };
    in
    {
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

      # the "libgit2 witness protection program" development environment
      devShells.${system}.libgitew = pkgs.mkShell {
        buildInputs = [
          pkgs.go
          pkgs.libgit2_1_1
          pkgs.pkg-config
        ];
        CGO_ENABLED = "1";
      };

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
