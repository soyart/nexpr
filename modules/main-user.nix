{lib, config, pkgs, ...}:

{
  options = {
    main-user.enable = lib.mkEnableOption "enable main-user.nix module";
    main-user.userName = lib.mkOption {
      type = lib.types.str;
      default = "nixuser";
    };
  };

  config = lib.mkIf config.main-user.enable {
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
