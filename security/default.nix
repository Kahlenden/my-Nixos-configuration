{ pkgs, ... }:
{
  imports = [./semi-active-av.nix];

  semi-active-av.enable = true;
  #environment.memoryAllocator.provider = "libc"; #"graphene-hardened";
  #nixpkgs.overlays = [
  #  (final: super: {
  #    dhcpcd = super.dhcpcd.override { enablePrivSep = false; };
  #  })
  #];
  # Allow the ip addresses below for virtualbox
  #environment.etc."vbox/networks.conf".text = '' * 10.10.0.0/24 '';
  security = {
    polkit.enable = true;
    sudo.execWheelOnly = true;
    wrappers.ubridge = {
      source = "${pkgs.ubridge}/bin/ubridge";
      capabilities = "cap_net_admin,cap_net_raw=ep";
      owner = "kahlenden";
      group = "users";
      permissions = "u+rx,g+x";
    };
  };
  nix.settings = {
    allowed-users = [ "@wheel" ];
    experimental-features = [ "nix-command" "flakes" ];
    sandbox = true;
  };

  networking = {
    #tcpcrypt.enable = true;
    #stevenblack = {
    #  enable = true;
    #  block = ["fakenews" "gambling"];
    #};
    networkmanager = {
      dhcp = "internal";
      enable = true;
      wifi = {
        scanRandMacAddress = true;
        macAddress = "random";
      };
      #ethernet.macAddress = "random";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    #wireless = {
    #  enable = true;  # Enables wireless support via wpa_supplicant.
    #  userControlled.enable = true;
    #  networks = {
    #    "programs.vim.defaultEditor = tru" = {
    #      hidden = true;
    #      psk = "abcdefgh";
    #    };
    #  };
    #};
    wireguard.enable = true;
    iproute2.enable = true;
  };
  services = {
    #MullvadVPN
    mullvad-vpn = {
      enable = true;
      # Set to true if need split tunneling
      enableExcludeWrapper = false;
    };
    resolved.enable = true;
  };
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

}
