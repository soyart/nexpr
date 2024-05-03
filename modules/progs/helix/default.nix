{  pkgs, username, ... }:

{
  home-manager.users."${username}" = {
    programs.helix = {
      enable = true;

      settings = {
        theme = "catppuccin_macchiato";
        editor = import ./editor.nix;
        keys = import ./keys.nix;
      };

      languages = import ./languages.nix { inherit pkgs; };
    };
  };
}
