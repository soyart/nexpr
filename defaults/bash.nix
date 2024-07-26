{  username, ... }:

{
  home-manager.users."${username}" = {
    programs.bash = {
      enable = true;
      historyControl = [ "ignoredups" ];
      historyFileSize = 512;
    };

    home.stateVersion = "24.05";
  };
}
