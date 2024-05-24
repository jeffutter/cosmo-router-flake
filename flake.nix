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
          version = "0.89.1";

          src =
            pkgs.fetchFromGitHub {
              owner = "wundergraph";
              repo = "cosmo";
              rev = "router@${version}";
              hash = "sha256-rWE+i3OWllqcIZEmeTxgqlbz1q4dI6SSY4QbG3D3CI8=";
            }
            + "/router";

          vendorHash = "sha256-46zz15mTLGQ5NuBUWCl6Gu1/shazcX7v24JxAjIiQrs=";

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