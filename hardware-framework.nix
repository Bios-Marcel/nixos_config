{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ 
    <nixos-hardware/framework/13-inch/12th-gen-intel>
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixwork";

  # Optimisations here have been thrown together from the nixos optimisations
  # repository.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ab3e3a17-d440-4d52-9630-a84ed5477c33";
      fsType = "ext4";
    };
}
 
