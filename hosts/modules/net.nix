{ config, pkgs, ... }: {
  programs.mtr.enable = true;
  
  networking = { 
    hostName = "laptop";

    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
    };

    firewall.enable = false;
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
