{
    description = "Python test server";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, utils }:
        utils.lib.eachDefaultSystem (system:
            let
                pkgs = nixpkgs.legacyPackages.${system};

                python = pkgs.python39;
                projectDir = ./.;

                overrides = pkgs.poetry2nix.overrides.withDefaults (final: prev: {
                # Python dependency overrides go here
                });
            in
            rec {
                packages = utils.lib.flattenTree {
                    default = with pkgs.poetry2nix; mkPoetryApplication {
                        inherit projectDir overrides python;
                        preferWheels = true;
                    };
                };

                apps.default = utils.lib.mkApp { drv = packages.default; };

                devShell = pkgs.mkShell {
                    buildInputs = [
                        (pkgs.poetry2nix.mkPoetryEnv {
                            inherit python projectDir overrides;
                            preferWheels = true;
                        })
                        pkgs.python39Packages.poetry
                        ];
                };
        }
    );
}
