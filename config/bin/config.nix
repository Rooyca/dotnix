{ config, pkgs, lib, ... }:

let
  configPath = "${config.home.homeDirectory}";
  configFile = "${configPath}/.config/bin/config.json";
  jsonContent = ''
{
    "default_path": "${configPath}/.local/bin",
    "bins": {
        "${configPath}/.local/bin/nb": {
            "path": "${configPath}/.local/bin/nb",
            "remote_name": "nb",
            "version": "7.21.3",
            "hash": "98efca78f4f38161b487ed314e9f08fa13210586bf4fa407cd4ff467b6fde81f",
            "url": "github.com/xwmx/nb",
            "provider": "github",
            "package_path": "",
            "pinned": false
        }
    }
}
'';
in
{
  home.activation.generateBinConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "${configFile}" ]; then
      mkdir -p "$(dirname ${configFile})"
      echo '${jsonContent}' > "${configFile}"
    fi
  '';
}
