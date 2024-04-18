{ lib, pkgs, ... }:

let
  mainUsername = "artnoi";

  txtPackage = import ../modules/packages/txtimport.nix { inherit pkgs lib; };
  myPackages = txtPackage ../modules/packages/base.txt
  ++ txtPackage ../modules/packages/devel.txt
  ++ txtPackage ../modules/packages/net.txt
  ++ txtPackage ../modules/packages/laptop.txt;

in
{
  imports =
    [
      ../modules/iwd.nix
      ../modules/main-user.nix
      ../modules/doas.nix
      ../modules/ramdisk1.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/31e319df-c4fe-48f5-82f5-49c7a5503119";
      preLVM = true;
      allowDiscards = true; 
    };   
  };

  ramDisks = {
    "/tmp" = {};
    "/rd".size = "2G";
  };

  mainUser = {
    enable = true;
    userName = mainUsername;
  };

  doas.enable = true;
  doas.settings = {
    keepSudo = false;
    users = [mainUsername];
    keepEnv = true;
    persist = true;
  };

  environment.systemPackages = [
    # Other packages go here
  ] ++ myPackages;
}

