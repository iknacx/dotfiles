inputs: let
  inherit (inputs.self) outputs;
  
  lib = inputs.nixpkgs.lib // inputs.home-manager.lib;

  mkPkgs = system: import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = builtins.attrValues outputs.overlays;
  };

  foldMergeAttrs = lib.foldAttrs lib.mergeAttrs {};
in {
  inherit mkPkgs foldMergeAttrs;
  
  perSystem = systems: fn:
    foldMergeAttrs (map (system: 
      (lib.mapAttrs (_: v: {${system} = v;}) (fn (mkPkgs system))))
    systems);

  hosts = lib.foldl lib.recursiveUpdate {};
  
  host = name: {
    username ? "iknacx",
    system ? "x86_64-linux",
    modules ? [],
    homeModules ? [],
  }: let
    pkgs = mkPkgs system;

    sysConfig = {
      nixosConfigurations.${name} = lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ../hosts/${name}
        ] ++ modules;
        specialArgs = { inherit inputs outputs; };
      };
    };

    homeConfig = {
      homeConfigurations.${name} = lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ../home/${name}
        ] ++ homeModules;
        extraSpecialArgs = { inherit inputs outputs; };
      };
    };

  in sysConfig // homeConfig;

}
