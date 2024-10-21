{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "nix_thinkpad";

  console.keyMap = "de";

  # Optimisations here have been thrown together from the nixos optimisations
  # repository.
  boot = {
    loader.grub.enable = true;
    loader.grub.useOSProber = false;
    loader.grub.device = "/dev/sda";

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
    { device = "/dev/disk/by-uuid/8dbdb726-f0d0-4ba8-843b-bba3343bb5e9";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/97ddbf27-9491-49c9-aac5-f20bc765e1d2"; }
    ];
}
