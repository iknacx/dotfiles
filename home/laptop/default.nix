{ config, pkgs, ... }: let
  username = "iknacx";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";
in {
  imports = [
    ../modules/rnnoise.nix
    ../modules/services.nix
    ../modules/hyprland.nix
  ];

  home.packages = with pkgs; [
    ranger fd ripgrep playerctl mpv
    kitty discord tdesktop obsidian blueman
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    })

    nodejs nodePackages.pnpm python3 clang gnumake rustup nim zig-overlay.master

    dunst brightnessctl
    swww eww-wayland rofi-wayland cliphist wl-clipboard grim slurp wlsunset wlogout
  ];
  
  # Shell
  programs.nushell.enable = true;
  programs.starship.enable = true;
  programs.starship.enableNushellIntegration = true;
  
  # Better cd
  programs.zoxide.enable = true;
  programs.zoxide.enableNushellIntegration = true;

  # Better cat
  programs.bat.enable = true;

  # Media control
  services.playerctld.enable = true;

  # Mount external disks as user
  services.udiskie.enable = true;

  # Best editor ever
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
  };

  xdg = {
    inherit configHome;
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  home = {
    inherit username homeDirectory;

    # Setup cursor
    pointerCursor = {
      x11.enable = true;
      gtk.enable = true;
      name = "macOS-BigSur";
      package = pkgs.apple-cursor;
    };

    stateVersion = "23.05";
  };
}
