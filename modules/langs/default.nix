{ lib, config, pkgs, username, ... }:

with lib;
with lib.types;

let
  cfg = config.nexpr.langs;

  mappings = {
    go = with pkgs; [
      go
      gopls
    ];

    rust = with pkgs; [
      cargo
      rust-analyzer
    ];
  };

  mod = {
    options = {
      enable = mkEnableOption "Enable language support";
      systemPackage = mkEnableOption "Enable language support as system package";
    };
  };

  langList = (langCfgs:
    mapAttrsFlatten
      (key: val: val // {name = key;})
    langCfgs
  );

  sysPkgs = (langList:
    map
      (lang: lib.optionals (lang.enable && lang.systemPackage)
        mappings."${lang.name}"
      )
    langList
  );

  homePkgs = (langList:
    map
      (lang: lib.optionals (lang.enable && !lang.systemPackage)
        mappings."${lang.name}"
      )
    langList
  );

in {
  options.nexpr.langs = mkOption {
      description = "Programming languages to install";
      type = attrsOf (submodule mod);
      default = {
        enable = false;
        systemPackage = false;
      };
  };
  
  config = 
  let
    languages = langList cfg;

  in {
    environment.systemPackages =
      lists.flatten (sysPkgs languages);

    home-manager.users."${username}".home.packages =
      lists.flatten (homePkgs languages);
  };
}
