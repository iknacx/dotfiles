{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [ docker-compose distrobox ];
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
}
