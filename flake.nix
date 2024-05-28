{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      # self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        router = pkgs.buildGoModule rec {
          pname = "router";
          version = "0.90.1";

          src =
            pkgs.fetchFromGitHub {
              owner = "wundergraph";
              repo = "cosmo";
              rev = "router@${version}";
              hash = "sha256-8B8ZZWHQfOyY+giy0F7Rt7eYQWcqLtRwUNme8uMoVB0=";
            }
            + "/router";

          vendorHash = "sha256-YXeIa4auisdobteVfqTH6z3dDa0NUsNBBDiO8XpxnJM=";

          CGO_ENABLED = 0;
          ldflags = [ "-extldflags '-static'" ];
          doCheck = false;

          meta = {
            description = "router";
          };
        };
      in
      with pkgs;
      {
        packages = {
          default = router;
        };

        devShells.default = mkShell { packages = [ router ]; };

        formatter = nixpkgs-fmt;
      }
    );
}
