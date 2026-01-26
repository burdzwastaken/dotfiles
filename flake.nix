{
  description = "Personal NixOS and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # opencode = {
    #   url = "github:anomalyco/opencode/v1.1.30";
    # };

    winboat.url = "github:TibixDev/winboat/v0.8.7";
  };

  # with imports `{ self, ... }@inputs: `
  outputs = { nixpkgs, nixpkgs-unstable, home-manager, winboat, ... }:
    let
      system = "x86_64-linux";

      overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable {
            system = prev.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
          # codex = prev.callPackage ./home/packages/codex.nix {
          #   unstable = final.unstable;
          # };
          # opencode = prev.callPackage ./home/packages/opencode.nix {
          #   opencode-src = opencode;
          # };
          winboat = prev.callPackage ./home/packages/winboat.nix {
            winboat-flake = winboat;
          };
          libgit2_1_3 = prev.libgit2.overrideAttrs (old: {
            version = "1.3.0";
            src = prev.fetchFromGitHub {
              owner = "libgit2";
              repo = "libgit2";
              rev = "v1.3.0";
              sha256 = "sha256-7atNkOBzX+nU1gtFQEaE+EF1L+eex+Ajhq2ocoJY920=";
            };
            patches = [ ];
            doCheck = false;
          });
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
        "matt_burdan" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/profiles/matt_burdan.nix ];
        };
      };

      # the "libgit2 witness protection program" development environment
      devShells.${system}.libgitew = pkgs.mkShell {
        buildInputs = [
          pkgs.go
          pkgs.libgit2_1_3
          pkgs.pkg-config
        ];
        CGO_ENABLED = "1";
      };

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
