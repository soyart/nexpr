{ inputs, ... }:

{
  # Basic config for home-manager.
  #
  # Do not import home-manager.nixosModules.home-manager
  # so that we can import this file from stand-alone home-manager setup.

  home-manager.home = {
    useGlobalPackages = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };
}
