{ inputs, lib, pkgs, ... }:

let
  hostname = "nexpr-t14";
  mainUsername = "artnoi";

in {
  imports = [
      inputs.home-manager.nixosModules.home-manager

      ../../hosts/t14/configuration.nix

      ../../modules/net/iwd.nix
      ../../modules/net/unbound.nix
      ../../modules/packages.nix
      ../../modules/main-user.nix
      ../../modules/doas.nix
      ../../modules/ramdisk.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ]; 

  # Blacklist some driver modules
  boot.blacklistedKernelModules = [
    "btusb"
    "bluetooth"
    "uvcvideo"
  ];

  hardware.bluetooth = {
    enable = false;
    powerOnBoot = false;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/31e319df-c4fe-48f5-82f5-49c7a5503119";
      preLVM = true;
      allowDiscards = true;
    };   
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = { inherit inputs; };
    users = {
      "${mainUsername}" = (import ./home.nix) { pkgs = pkgs; };
    };
  };

  networking.hostName = hostname;

  nexpr = {
    ramDisks = {
      "/tmp" = {};
      "/rd".size = "2G";
    };

    mainUser = {
      enable = true;
      username = mainUsername;
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

    net = {
      iwd.enable = true;
      unboundDoT = {
        enable = true;
        nameserversDoT = [
          "1.1.1.1@853#one.one.one.one"
          "1.0.0.1@853#one.one.one.one"
          "9.9.9.9@853#dns.quad9.net"
        ];
      };
    };

    packages = [
      ../../packages/base
      ../../packages/devel
      ../../packages/net
      ../../packages/laptop
      ../../packages/nix-extras
    ];
  };

  environment.systemPackages = [
    # Other packages go here
  ];
}

