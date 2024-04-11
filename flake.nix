{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/093051473fd84cce950f574e77754353a5731463";#nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, lanzaboote, /*nix-vscode-extensions,*/ home-manager, nixpkgs, hyprland, ... }@inputs:
  let
    username = "kahlenden";
    hostname = "Windows11";
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      #overlays = [ inputs.nix-vscode-extensions.overlays.default ];
      config.allowUnfree = true;
    }; 
  in
  {
    nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [ 
        lanzaboote.nixosModules.lanzaboote
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = {
            imports = [ ./home.nix ];
            home.stateVersion = "24.05";
          };
          home-manager.extraSpecialArgs = {inherit inputs username; };
        }
        ({ pkgs, lib, ... }: {
        # Lanzaboote currently replaces the systemd-boot module.
          system.stateVersion = "24.05"; 
          boot.loader.systemd-boot.enable = lib.mkForce false;
          boot.lanzaboote = {
            enable = true;
            pkiBundle = "/etc/secureboot";
          };
        })
      ];
    };
  };
}
