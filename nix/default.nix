{
  lib,
  python3,
  tmuxPlugins,
  version,
  ...
}:
tmuxPlugins.mkTmuxPlugin {
  inherit version;
  pluginName = "tmux-which-key";
  propagatedBuildInputs = [python3];
  src = lib.cleanSource ../.;
  preInstall = ''
    rm -rf plugin/pyyaml
    cp -r ${python3.pkgs.pyyaml.src} plugin/pyyaml
  '';
  rtpFilePath = "plugin.sh.tmux";
}
