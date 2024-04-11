{lib, pkgs, ...}: {

  services.hardware.bolt.enable = true;
  boot = {
    # Ensure module for external graphics is loaded
    initrd.kernelModules = [ "amdgpu" ];
  
    kernelParams = [
      "amdgpu.pcie_gen_cap=0x40000"
      "udev.log_level=3"
    ];
  };
  # Use external graphics
  services.xserver = {
    videoDrivers = [ "modesetting"];
/*
    # Load amdgpu first
    serverLayoutSection = ''
      Screen "Screen-amdgpu"
    '';
    # add section for amdgpu because it doesn't overwrite amdgpu[0] for some reason
    config = lib.mkAfter ''
      Section "Device"
        Identifier "Device-amdgpu"" 
        BusID      "PCI:06:00:0"
        Option     "AllowExternalGpus" "True"
        Option     "AllowEmptyInitialConfiguration"
      EndSection

      Section "Screen"
        Identifier "Screen-amdgpu"
        Device "Device-amdgpu"
        Monitor "Monitor[0]"
      EndSection
    '';
*/
  };
  hardware = { 
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
}

