{inputs, pkgs, config, ...}:
{
  imports = [
    ./sddm-theme
  ];
  home-manager.users.kahlenden = import ./hyprdot.nix;
  services = {
    xserver.displayManager.sddm.enable = true;
    gvfs.enable = true;
    devmon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    gnome = {
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };
  };
  programs = {
    light.enable = true;
    sway = {
      enable = true;
      extraPackages = with pkgs; [swaylock-effects swayidle];
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };

  environment.sessionVariables = {
    # if cursor invisible
    WLR_NO_HARDWARE_CURSOR = "1";
    # hint electron to use wayland
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    opengl.enable = true;
    # most wayland compositor needs (i dont use nvidia tho) 
    #nvidia.modesetting.enable = true;
  };

  environment.systemPackages = with pkgs; [
  wvkbd
  brightnessctl
  networkmanagerapplet
  hyprpicker
  wlogout
  gnome.nautilus
  waybar
  #dunst
  #libnotify  # Dunst need this to display notifications
#  hyprpaper  swaybg  wpaperd  mpvpaper # Other wallpaper daemons
  swww   # <- Wallpaper deamon, can use others, like above there
  rofi-wayland # App launcher
# Alternatively, for app launcher: rofi-wayland wofi bemenu fuzzel tofi
#  pamixer
  playerctl
  grim
  starship
  cava
  imagemagick
  gnome.gnome-bluetooth
  wl-clipboard
  wf-recorder
  libdbusmenu-gtk3
  slurp
  theme-sh
  #  (callPackage ./flick0-dot.nix{}).flick0-dot
  ];
  /*  The below config configs the way apps interacting with each other:
  *   Screen Sharing, link opening, file opening, etc... */
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
