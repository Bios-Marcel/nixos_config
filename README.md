# NixOS configuration

My device-agnostic Nix OS configuration.

**Do not clone directly into `/etc/nixos`.** This is annoying due to having to
call `sudoedit`.

## How to apply configuration

1. Edit files in this repository
2. Sync to `/etc/nixos/` by running `sudo ./sync.sh`
3. Rebuild via `sudo nixos-rebuild switch`

## Hardware configuration

The hardware configuration is spread across files.

Hierarchy:

* `hardware-configuration.nix`
  > Contains generic configuration.
* `hardware-<device-type>.nix`
  > Contains device specific configuration and imports the generic configuration.
* `hardware-config-import.nix`
  > Decides which hardware specific configuration is imported and isn't tracked
  > by git. This file is then imported by `configuration.nix`.

Since the concrete hardware configurations most likely use community provided
defaults, install the given channel:

```sh
sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
sudo nix-channel --update
```

To add a new machine, check out the repo and create the
`hardware-config-import.nix` and decide whether you need a new device specific
configuration or import the generic one.

The file looks like this:

```nix
{ config, ... }:

{
  imports = [ ./hardware-thinkpad-l570.nix ];
}
```

For the concrete hardware configuration, you'll also have to specify the
filesystem. For this, you need the UUID of the drives. You can list the UUIDs
via `ls /dev/disk/by-uuid`.

Then add the following section:

```nix
  fileSystems."/" =
    { device = "/dev/disk/UUID";
      fsType = "ext4";
    };
```

## Issues

* IntelliJ doesn't automatically find the JDK22, the workaround for now is
  manual installation via IntelliJ, even though this will duplicate the JDK.

