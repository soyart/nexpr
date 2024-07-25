{ pkgs, hostname, mainUser, ... }:

{
  imports = [
      ./hardware.nix
      ./configuration.nix

      ../../modules/net
      ../../modules/syspkgs.nix
      ../../modules/main-user.nix
      ../../modules/doas.nix # doas is considered a system setting
      ../../modules/ramdisk.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ]; 

  nix.optimise = {
    automatic = true;
  };

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

  networking.hostName = hostname;

  nexpr = {
    ramDisks = {
      "/tmp" = {
        group = "wheel";
      };
      "/rd" = {
        size = "2G";  
        group = mainUser;
        owner = mainUser;
      };
    };

    mainUser = {
      enable = true;
      username = mainUser;
    };

    doas = {
      enable = true;
      keepSudo = false;
      settings = {
          users = [ mainUser ];
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

      firewall = {
        enable = true;
        global = {
          allowPing = false;
        };
      };
    };

    syspkgs = [
      ../../../packages/base
      ../../../packages/devel
      ../../../packages/net
      ../../../packages/laptop
      ../../../packages/nix-extras
    ];
  };

  programs.nano.enable = false;
  environment.systemPackages = [
    # Other packages go here
  ];

  services.automatic-timezoned.enable = true;
}
