{
  description = "Configuración NixOS de Mikuri";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
#    oxicord.url = "github:linuxmobile/oxicord";

    noctalia-shell = {
      url = "github:Noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

 #   nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

    mikuboot = {
      url = "gitlab:evysgarden/mikuboot";
      inputs.nixpkgs.follows = "nixpkgs";
    };

#    slowfetch = {
#      url = "github:tuibird/Slowfetch";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elyprismlauncher.url = "github:ElyPrismLauncher/ElyPrismLauncher/10.0.2";

    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        {
          nixpkgs.config.allowUnfree = true;
      #    nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
        }

        inputs.mikuboot.nixosModules.default
        inputs.mango.nixosModules.mango

        ./configuration.nix
        ./sddm.nix
        ./kernel.nix
        ./servicio.nix
        ./portal.nix
        ./pkgs.nix

        {
          programs.mango.enable = true;
        }

        {
          environment.systemPackages = with nixpkgs.legacyPackages.x86_64-linux; [

            inputs.noctalia-shell.packages.x86_64-linux.default
            inputs.elyprismlauncher.packages.x86_64-linux.default
            inputs.quickshell.packages.x86_64-linux.default
 #           inputs.slowfetch.packages.x86_64-linux.default
          ];
        }
      ];
    };
  };
}
