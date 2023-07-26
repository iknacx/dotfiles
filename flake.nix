{
  description = "My Nix Configuration";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    home-manager.url = github:nix-community/home-manager;

    hyprland.url = github:hyprwm/hyprland;
    lanzaboote.url = github:nix-community/lanzaboote;


    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: let
    lib = import ./lib inputs;
    inherit (lib) perSystem hosts host;
  in {
    inherit lib;

    nixosModules = import ./modules/nixos;
    homeModules = import ./modules/home;

    overlays = import ./overlays inputs;
  
  } // perSystem ["x86_64-linux" "aarch64-linux"] (pkgs: {
    formatter = pkgs.alejandra;
    packages = import ./packages pkgs;
  }) // hosts [
    (host "laptop" {
      modules = [ inputs.lanzaboote.nixosModules.lanzaboote ];
    })
  ];
}
