{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    home-manager
    neovim
    wget
  ];

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
      font-awesome
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ];  })
    ];
  };
}
