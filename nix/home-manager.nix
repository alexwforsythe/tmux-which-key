self: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.tmux.tmux-which-key;
  pluginPath = "tmux-plugins/tmux-which-key";
  defaultPackage = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  options.programs.tmux.tmux-which-key = {
    enable = lib.mkEnableOption "tmux-which-key";

    package = lib.mkOption {
      type = with lib.types; nullOr package;
      default = defaultPackage;
      defaultText = lib.literalExpression "inputs.tmux-which-key.packages.${pkgs.stdenv.hostPlatform.system}.default";
      description = ''
        The tmux-which-key package to use.

        By default, this option will use the `packages.default` as exposed by this flake.
      '';
    };

    settings = lib.mkOption rec {
      type = with lib.types; let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "tmux-which-key configuration value";
          };
      in
        valueType;
      default = import ./generate-config.nix {inherit lib pkgs;};
      description = "tmux-which-key plugin configuration";
      example = default;
    };
  };

  config = let
    configYaml =
      pkgs.runCommandNoCC "config.yaml" {
        nativeBuildInputs = cfg.package.propagatedBuildInputs;
      } ''
        echo '# yaml-language-server: $schema=config.schema.yaml' > $out
        echo '${lib.generators.toYAML {} cfg.settings}' >> $out
        check-jsonschema -v \
          --schemafile "${cfg.package}/share/tmux-plugins/tmux-which-key/config.schema.yaml" \
          $out
      '';
    configTmux =
      pkgs.runCommandNoCC "init.tmux" {
        nativeBuildInputs = cfg.package.propagatedBuildInputs;
      } ''
        python3 "${cfg.package}/share/tmux-plugins/tmux-which-key/plugin/build.py" ${configYaml} $out
      '';
  in
    lib.mkIf cfg.enable {
      xdg = {
        configFile."${pluginPath}/config.yaml".source = configYaml;
        dataFile."${pluginPath}/init.tmux".source = configTmux;
      };
      programs.tmux.plugins = [
        {
          plugin = cfg.package;
          extraConfig = ''
            set -g @tmux-which-key-xdg-enable 1;
            set -g @tmux-which-key-disable-autobuild 1
            set -g @tmux-which-key-xdg-plugin-path "${pluginPath}"
          '';
        }
      ];
    };
}
