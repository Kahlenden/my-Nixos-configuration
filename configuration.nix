# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./vm.nix
      ./amd_egpu.nix
      ./shell.nix
      #./egpu-passthrough.nix
      #./gnome
      ./hyprland
      ./packages
      ./security
    ];

#  specialisation."VFIO".configuration = {
#    system.nixos.tags = [ "with-vfio" ];
#    vfio.enable = true;
#  };

  services.logind.extraConfig = ''
    # Don’t suspend when close lid
    HandleLidSwitch=ignore
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
    LidSwitchIgnoreInhibited=no
  '';
  
  boot.kernelParams = [ "i915.force_probe=46a6" ];
  # Set swappiness
  boot.kernel.sysctl = { "vm.swappiness" = 2; };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "Windows_11"; # Define your hostname. 

  # NetworkManager
  programs.nm-applet = {
    enable = true;
    indicator = true;
  };
  # Bluetoooth
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  # Audio
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraConfig = "load-module module-combine-sink";
  };
  services.pipewire.enable = true;
  sound.enable = true;
  security.rtkit.enable = true;

  services.xserver = {
    enable = true;
    logFile = "/var/log/xorg.log";
    libinput.touchpad = {
      #enable = true;
      tapping = true;
      naturalScrolling = true;
      clickMethod = "clickfinger";
      disableWhileTyping = true;
    };
    xkb = {
      layout = "us";
      variant = "";
    };
  };


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Denver";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

/*
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
*/
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    #groups.tcpcryptd = {};
    users = {
      #tcpcryptd.group = "tcpcryptd";
      kahlenden = {
        isNormalUser = true;
        description = "Kahlenden";
        extraGroups = [ "networkmanager" "wheel" "video" "audio" "libvirtd" ];
        packages = with pkgs; [
          gns3-gui
          #firefox
          #thunderbird
        ];
      }; 
    };
  };


  # Static ip address
#  networking.interfaces.eth0.ipv4.addresses = [ {
#    address = "10.0.0.37";
#    prefixLength = 24;
#  } ];


    # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # Did you read the comment?


  # Automatic Garbage Collection
  nix.gc = {
     automatic = true;
     dates = "weekly";
     options = "--delete-older-than 7d";
   };

  # Auto system update
  system.autoUpgrade = {
    enable = true;
  };

  #console configs
  fonts.packages = with pkgs; [nerdfonts font-awesome ucs-fonts freefont_ttf];

  # set default apps
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "mullvad-browser.desktop";
      "x-scheme-handler/http" = "mullvad-browser.desktop";
      "x-scheme-handler/https" = "mullvad-browser.desktop";
      "x-scheme-handler/about" = "mullvad-browser.desktop";
      "x-scheme-handler/unknown" = "mullvad-browser.desktop";
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
      "application/msword" = "writer.desktop";
      "video/*" = "vlc.desktop"; 
    };
  };

  # Disable swap
  # swapDevices = lib.mkForce [ ];

}
