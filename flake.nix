{ inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    utils.url = github:numtide/flake-utils;
  };

  outputs = { nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        compiler = "ghc92";

        config = { allowBroken = true; allowUnsupportedSystem = true; };

        hsLib = pkgs.haskell.lib.compose;

        overlay = pkgsNew: pkgsOld: {
          flora = hsLib.addBuildTools [ pkgs.souffle ]
            (hsLib.justStaticExecutables pkgsNew.haskellPackages.flora);

          haskell =
            pkgsOld.haskell // {
              packages = pkgsOld.haskell.packages // {
                "${compiler}" =
                  pkgsOld.haskell.packages."${compiler}".override (old: {
                    overrides =
                      pkgsNew.lib.fold
                        pkgsNew.lib.composeExtensions
                        (old.overrides or (_: _: { }))
                        [ (pkgsNew.haskell.lib.packageSourceOverrides {
                            flora = ./.;
                          })
                          (pkgsNew.haskell.lib.packagesFromDirectory {
                            directory = ./nix;
                          })
                          (haskellPackagesNew: haskellPackagesOld: {
                            conduit-extra = hsLib.dontCheck haskellPackagesOld.conduit-extra;
                            lucid-alpine = hsLib.doJailbreak haskellPackagesOld.lucid-alpine;
                            lucid-aria = hsLib.doJailbreak haskellPackagesOld.lucid-aria;
                            lucid-svg = hsLib.doJailbreak haskellPackagesOld.lucid-svg;
                            microlens-platform = hsLib.doJailbreak haskellPackagesOld.microlens-platform;
                            postgresql-migration = hsLib.doJailbreak haskellPackagesOld.postgresql-migration;
                            postgresql-simple-migration = hsLib.doJailbreak haskellPackagesOld.postgresql-simple-migration;
                            pg-entity = hsLib.dontCheck haskellPackagesOld.pg-entity;
                            pg-transact = hsLib.dontCheck haskellPackagesOld.pg-transact;
                            prometheus-proc = hsLib.doJailbreak haskellPackagesOld.prometheus-proc;
                            raven-haskell = hsLib.dontCheck (hsLib.doJailbreak haskellPackagesOld.raven-haskell);
                            servant-lucid = hsLib.doJailbreak haskellPackagesOld.servant-lucid;
                            servant-static-th = hsLib.dontCheck haskellPackagesOld.servant-static-th;
                            slugify = hsLib.dontCheck haskellPackagesOld.slugify;
                            souffle-haskell = hsLib.dontCheck (hsLib.doJailbreak haskellPackagesOld.souffle-haskell);
                            text-metrics = hsLib.doJailbreak haskellPackagesOld.text-metrics;
                            type-errors-pretty = hsLib.dontCheck (hsLib.doJailbreak haskellPackagesOld.type-errors-pretty);

                            flora = hsLib.addBuildTool pkgsNew.souffle
                              (hsLib.dontCheck (hsLib.doJailbreak haskellPackagesOld.flora));

                            Cabal-syntax = haskellPackagesNew.Cabal-syntax_3_8_1_0;

                            text = haskellPackagesNew.text_2_0_1;

                            lens-aeson = haskellPackagesNew.lens-aeson_1_2_2;
                            
                            monad-time = haskellPackagesNew.monad-time_0_4_0_0;

                            parsec = haskellPackagesNew.parsec_3_1_15_1;

                            PyF = haskellPackagesNew.PyF_0_11_1_0;
                          })
                        ];
                  });
              };
            };
        };

        pkgs =
          import nixpkgs { inherit config system; overlays = [ overlay ]; };

      in
        rec {
          packages.default = pkgs.haskell.packages."${compiler}".flora;

          apps.default = {
            type = "app";

            program = "${pkgs.flora}/bin/flora";
          };

          devShells.default = pkgs.haskell.packages."${compiler}".flora.env.overrideAttrs (old: {
            buildInputs = old.buildInputs ++ [
              pkgs.cabal-install
              pkgs.gnumake
              pkgs.postgresql
              pkgs.haskell.packages."${compiler}".postgresql-migration
              pkgs.yarn
            ];
          });
        }
    );
}

