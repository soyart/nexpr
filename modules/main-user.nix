{lib, config, ...}:
with lib;

{
  options = {
    main-user.enable = mkEnableOption "enable main-user.nix module";
    main-user.userName = mkOption {
      type = types.str;
      default = "nixuser";
    };
  };

  config = mkIf config.main-user.enable {
    users.users.${config.main-user.userName} = {
      isNormalUser = true;
      home = "/home/${config.main-user.userName}";
      createHome = true;
      extraGroups = [
        "wheel"
      ];
    };
  };
}
