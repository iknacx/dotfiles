{ config, pkgs, ... }: {
  users.users.iknacx = {
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" "disk" ];
  };
}
