{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware.nix
    ../modules/nix.nix
    ../modules/net.nix
    ../modules/virt.nix
    ../modules/users.nix
    ../modules/nvidia.nix
    ../modules/locale.nix
    ../modules/touchpad.nix
    ../modules/pipewire.nix
    ../modules/packages.nix
  ];

  boot = {
    bootspec.enable = true;
    loader.efi.efiSysMountPoint = "/efi";
    loader.efi.canTouchEfiVariables = true;

    # Disable systemd-boot for enabling secure-boot
    loader.systemd-boot.enable = lib.mkForce false;
    # Bootloader with secure-boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
      configurationLimit = 4;
    };
  };
  
  hardware.enableRedistributableFirmware = true;

  # Swap
  zramSwap.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # D-Bus
  services.dbus.enable = true;
  programs.dconf.enable = true;
  services.upower.enable = true;

  # Disks
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Graphical
  services.xserver.enable = true;
  # LightDM is enabled by default when there is no DM
  services.xserver.displayManager.lightdm.enable = lib.mkForce false;
  # Window Manager >>> Desktop Environment
  programs.hyprland = {
    enable = true;
    nvidiaPatches = true;
    xwayland.enable = true;
    package = pkgs.hyprland-dev; # This is an overlay
  };

    # SSH|GPG
  services.openssh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Misc
  services.printing.enable = true;
}
