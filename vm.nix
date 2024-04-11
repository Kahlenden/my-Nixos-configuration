{ config, user, pkgs, ... }:

{
  
  # Enable dconf (System Management Tool)
  programs.dconf.enable = true;
  # Home manager module
  home-manager.users.kahlenden = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    home-manager
    qemu
    libvirt
    ebtables
    dnsmasq
    virt-manager
    virt-viewer
    spice spice-gtk
    spice-protocol
    win-virtio
    win-spice
    virtiofsd
  ];
  programs.virt-manager.enable = true;

  # Manage the virtualisation services
  virtualisation = {
      # Virtualbox configuration
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
      guest = {
        enable = true;
        x11 = true;
      };
    };

    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
      allowedBridges = [ "virbr0" ];
    };
    spiceUSBRedirection.enable = true; 
  };
  services.spice-vdagentd.enable = true;

}
