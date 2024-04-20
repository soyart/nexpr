{ pkgs, ... }:

let
  hostname = "nexpr-t14";
  mainUsername = "artnoi";

in
{
  imports =
    [
      ../../modules/net/iwd.nix
      ../../modules/net/unbound.nix

      ../../modules/packages.nix
      ../../modules/main-user.nix
      ../../modules/doas.nix
      ../../modules/ramdisk.nix
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

  iwd.enable = true;

  mainUser = {
    enable = true;
    userName = mainUsername;
  };

  doas = {
    enable = true;
    keepSudo = false;
    settings = {
        users = [ mainUsername ];
        keepEnv = true;
        persist = true;
    };
  };

  networking.hostName = hostname;
  # networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

  unboundDoT = {
    enable = true;
    nameserversDoT = [
      "1.1.1.1@853#one.one.one.one"
      "1.0.0.1@853#one.one.one.one"
      "9.9.9.9@853#dns.quad9.net"
    ];
  };

  packages = [
    ../../packages/base.txt
    ../../packages/devel.txt
    ../../packages/net.txt
    ../../packages/laptop.txt
  ];

  environment.systemPackages = [
    # Other packages go here
  ];
}

