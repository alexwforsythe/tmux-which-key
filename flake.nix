{
  description = "A plugin for tmux that allows users to select actions from a customizable popup menu";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    inherit (nixpkgs) lib;
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
    pkgsFor = lib.genAttrs systems (system: import nixpkgs {inherit system;});
    forAllSystems = f: lib.genAttrs systems (system: f pkgsFor.${system});
    version = self.sourceInfo.shortRev or self.sourceInfo.dirtyShortRev;
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    packages = forAllSystems (pkgs: {
      default = pkgs.callPackage ./nix {inherit version;};
    });

    homeManagerModules.default = import ./nix/home-manager.nix self;

    overlays.default = final: prev: {
      tmuxPlugins =
        prev.tmuxPlugins
        // {
          tmux-which-key = final.default;
        };
    };

    apps = forAllSystems (pkgs: let
      defaultConfig = import ./nix/generate-config.nix {
        inherit lib pkgs;
      };
    in {
      generate-config = {
        name = "generate-config";
        type = "app";
        program = "${pkgs.writeShellScriptBin "generate-config" ''
          echo '${lib.generators.toPretty {} defaultConfig}';
        ''}/bin/generate-config";
      };
    });
  };
}
