{ inputs, username, ... }:

{
  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };

      users = {
        "${username}" = {
          programs.bash = {
            enable = true;
            historyControl = [ "ignoredups" ];
            historyFileSize = 512;
          };

          home.stateVersion = "24.05";
        };
      };
    };
  };
}
