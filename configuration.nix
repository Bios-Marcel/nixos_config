# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DIS\{AY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

in
{
  imports =
    [
      ./hardware-config-import.nix
      ./login-manager.nix
    ];

  # NOTE that this might not actually clean up everything. Needs more
  # investigation.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.settings.experimental-features = [ "nix-command" ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  users.users.marcel = {
    isNormalUser = true;
    description = "marcel";
    extraGroups = [ "networkmanager" "wheel" "docker"];
  };

  nixpkgs.config.allowUnfree = true;
  virtualisation.docker.enable = true;

  environment.sessionVariables = rec {
    PATH = "~/go/bin";
    EDITOR = "nvim";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    tenacity
    pavucontrol

    # Communication
    discord
    telegram-desktop
    whatsapp-for-linux

    # basic
    spotify
    firefox
    chromium
    bitwarden
    chezmoi

    #
    # hardware control
    #
    brightnessctl
    # pipewire volume, i dont want pulse / alsa interfaces
    pw-volume
    bluez

    #
    # programming
    #
    cmake
    openssh
    git
    gdb
    clang-tools
    go
    # Used for plotting graphs, such as for pprof
    graphviz
    gcc
    nodejs_22
    gnumake
    tokei
    flyctl
    inkscape
    #
    # language servers
    #
    lua-language-server
    marksman
    gopls

    #
    # terminal
    #
    obs-studio
    presenterm
    bash-completion
    ripgrep
    fzf
    hyperfine
    sd
    jq
    fastfetch
    htop
    wezterm
    tmux
    neovim

    #
    # wayland specific
    #
    # screenshots
    slurp
    grim

    #
    # Desktop environment 
    #
    greetd.tuigreet
    playerctl
    i3blocks
    # Notifications
    mako
    dbus-sway-environment
    wl-clipboard
    xdg-utils
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.intone-mono
  ];

  services.tailscale.enable = true;

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "marcel";
    dataDir = "/home/marcel/sync";  # default location for new folders
    configDir = "/home/marcel/.config/syncthing";  # default location for new folders
  };

  services.dbus.enable = true;
  # intel cpu management stuff
  services.tlp.enable = true;

  programs.ssh.startAgent = true;

  # Use this so we have java_home set automatically:
  programs.java = {
    enable = true;
    package = pkgs.jdk23;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.steam.enable = true;

  # I use nvim
  programs.nano.enable = false;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
        swaylock-effects swayidle dmenu wmenu
    ];
  };

  # Multi monitor management
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart  = ''#{pkgs.kanshi -c kanshi_config_file'';
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # FIXME This does not work yet ... not sure why.
  # Prevent docker from booting initially, as we don't really need it by
  # default. However, being able to start it on demand is still required.
  systemd.services.docker.wantedBy = lib.mkForce [];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Not configure anyway, so I might aswell not have the packages installed.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
