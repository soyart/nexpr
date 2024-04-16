{lib, config, ...}:
with lib;

{
  options = {
    mainUser.enable = mkEnableOption "enable mainUser.nix module";
    mainUser.userName = mkOption {
      type = types.str;
      default = "nixuser";
    };
  };

  config = mkIf config.mainUser.enable {
    users.users.${config.mainUser.userName} = {
      isNormalUser = true;
      home = "/home/${config.mainUser.userName}";
      createHome = true;
      extraGroups = [
        "wheel"
      ];
    };
  };
}
