{
  description = "flake de  Mikuri";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    noctalia-shell.url = "github:Noctalia-dev/noctalia-shell";
    matugen.url = "github:InioX/Matugen/matugen-v0.10.0";

    mikuboot = {
      url = "gitlab:evysgarden/mikuboot";
      inputs.nixpkgs.follows = "";
    };

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
 
  };

  outputs = { self, nixpkgs, matugen, mikuboot, quickshell, noctalia-shell, silentSDDM, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
 
      specialArgs = {
        inherit inputs;
       };  
     
       modules = [
        ./configuration.nix
        mikuboot.nixosModules.default 
        {
          environment.systemPackages = [
            noctalia-shell.packages.x86_64-linux.default
          ];
        }
      ];
    };
  };
}
