{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "nixwork";

  # Optimisations here have been thrown together from the nixos optimisations
  # repository.
  boot = {
    # nodev for EFI only
    loader.grub.device = "nodev";

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
    { device = "/dev/disk/by-uuid/9c51e741-e2c5-4429-9650-7fbb1fa5b8d7";
      fsType = "ext4";
    };
}

