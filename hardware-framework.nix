{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "nixwork";

  # Optimisations here have been thrown together from the nixos optimisations
  # repository.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" ];
    initrd.kernelModules = [ "i915" ];
    kernelModules = [
      "kvm-intel"
      "acpi_call"
    ];
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
    ];
    kernelParams = [
      "i915.enable_fbc=1"
      "i915.enable_psr=2"
    ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ab3e3a17-d440-4d52-9630-a84ed5477c33";
      fsType = "ext4";
    };
}
 
