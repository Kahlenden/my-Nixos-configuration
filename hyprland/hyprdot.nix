{config, inputs, pkgs, ...}:
let
  bg = ./bg.jpg;
  startUpScript = pkgs.pkgs.writeShellScriptBin "start" ''
    swww init &
    sleep 1
    swww img -o HDMI-A-1 ${bg} &
    swww img -o eDP-1 ${bg} &
    mullvad-vpn &
    ags -b hypr &
  '';
  startOnSpecialWorkspace = pkgs.pkgs.writeShellScriptBin "start" ''
    sleep 1
    qbittorrent &
    super-productivity &
    youtube-music &
  '';
  lockscreen = pkgs.pkgs.writeShellScriptBin "lockscreen" ''
    swaylock --screenshots --indicator --clock \
    --inside-wrong-color f38ba8  \
    --ring-wrong-color 11111b  \
    --inside-clear-color a6e3a1 \
    --ring-clear-color 11111b \
    --inside-ver-color 89b4fa \
    --ring-ver-color 11111b \
    --text-color  f5c2e7 \
    --indicator-radius 80 \
    --indicator-thickness 5 \
    --effect-blur 10x7 \
    --effect-vignette 0.2:0.2 \
    --ring-color 11111b \
    --key-hl-color f5c2e7 \
    --line-color 313244 \
    --inside-color 0011111b \
    --separator-color 00000000 \
    --fade-in 0.1 &
  '';
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
in 
{
  imports = [
    inputs.ags.homeManagerModules.default
    inputs.hyprland.homeManagerModules.default
    ./waybar.nix
  ];
  programs.ags = {
    enable = true;
    configDir = ./ags;
    extraPackages = [ pkgs.libsoup_3 ];
  };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    plugins = [
      inputs.hyprgrass.packages.${pkgs.system}.default
#      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    settings = {
      exec-once = ''${startUpScript}/bin/start'';
      exec = "pkill swayidle; swayidle -w timeout 600 '${lockscreen}/bin/lockscreen' timeout 601 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep '${lockscreen}/bin/lockscreen'";
      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgba(D4CFB8FF)";
        "col.inactive_border" = "rgba(4B4742FF)";

        layout = "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 0; 
        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = "on";
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.8;
        }; 
      drop_shadow = "no";
      #shadow_range = 0;
      #shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = "yes";
        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        bezier = [
        "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      windowrule = [
        "float,title:^(Amberol)$"
        "size 420 720,title:^(Amberol)$"
        "move center center,title:^(Amberol)$"
      ];
      
      workspace = [
        "special:magic, on-created-empty: ${startOnSpecialWorkspace}/bin/start"
      ]; 

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = "yes"; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_is_master = true;
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = "yes";
        workspace_swipe_fingers = 3;
        workspace_swipe_cancel_ratio = 0.15;
      };

      misc = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        force_default_wallpaper = -1; # Set to 0 to disable the anime mascot wallpapers
      };

    # Example per-device config
    # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
#      "device:epic-mouse-v1" = {
#        sensitivity = -0.5;
#      };

      input = {
        kb_layout = "us";
#        kb_variant =
#        kb_model =
#        kb_options =
#        kb_rules =
        follow_mouse = 1;
        touchpad = {
          natural_scroll = "no";
          disable_while_typing = true;
        };
      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      "plugin:touch_gestures" = {
      # The default sensitivity is probably too low on tablet screens,
      # I recommend turning it up to 4.0
        sensitivity = 3.0;

      # must be >= 3
        #workspace_swipe_fingers = 3;

      # switching workspaces by swiping from an edge, this is separate from workspace_swipe_fingers
      # and can be used at the same time
      # possible values: l, r, u, or d
      # to disable it set it to anything else
        #workspace_swipe_edge = ["l" "r"];

      # in milliseconds
        long_press_delay = 400;
/*
        experimental {
    # send proper cancel events to windows instead of hacky touch_up events,
    # NOT recommended as it crashed a few times, once it's stabilized I'll make it the default
          send_cancel = 0
        }
*/
      };

      monitor = ",highres,auto,1";

      "$mod" = "SUPER";
      "$mod2" = "ControlAlt";

      "$menu" = "ags -b hypr -t launcher";
      "$powermenu" = "ags -b hypr -t powermenu";
      "$terminal" = "kitty";
      "$screenShot" = ''grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot copied to clipboard" -a "ss"'';
      "$fileManager" = "nautilus";
      "$code" = "codium";
      "$browser" = "mullvad-browser";
      binds = {
        allow_workspace_cycles = true;
      };
      bindle =  [
        ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
        ",XF86MonBrightnessDown, exec, ${brightnessctl} set  5%-"
        ",XF86KbdBrightnessUp,   exec, ${brightnessctl} -d asus::kbd_backlight set +1"
        ",XF86KbdBrightnessDown, exec, ${brightnessctl} -d asus::kbd_backlight set  1-"
        ",XF86AudioRaiseVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
        ",XF86AudioLowerVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
      ];
      bindl = [
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPrev, exec, playerctl previous"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
        ", XF86AudioMute, exec, ${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86PowerOff, exec, $powermenu"
        #",switch:off:Lid Switch,exec,${lockscreen}/bin/lockscreen"
        #",switch:off:Lid Switch,exec,hyprctl dispatch dpms off"
        #",switch:on:Lid Switch,exec,hyprctl dispatch dpms on"
      ];
      bind = [
        "Alt, F4, killactive,"
        "$mod, F, fullscreen"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating," 
        "SUPER_L, SUPER_L, exec, $menu"
        ",Print, exec, $screenShot"
        "$mod2, T, exec, $terminal"
        "$mod, P, pseudo," # dwindle
        "$mod, J, togglesplit," # dwindle
        "$mod, C, exec, $code"
        "$mod, B, exec, $browser"
        "$mod, L, exec, ${lockscreen}/bin/lockscreen"
        "Control Shift, Escape, exit"
        "Control Shift, R, exec, ags -b hypr quit; ags -b hypr" 

        # change direction of monitor 
        "ALT, up, exec,    hyprctl --batch 'keyword monitor eDP-1,preferred,auto,1,transform,0 ; keyword input:touchdevice:transform 0'"
        "ALT, right, exec, hyprctl --batch 'keyword monitor eDP-1,preferred,auto,1,transform,3 ; keyword input:touchdevice:transform 3'"
        "ALT, down, exec,  hyprctl --batch 'keyword monitor eDP-1,preferred,auto,1,transform,2 ; keyword input:touchdevice:transform 2'"
        "ALT, left, exec,  hyprctl --batch 'keyword monitor eDP-1,preferred,auto,1,transform,1 ; keyword input:touchdevice:transform 1'"

        # Move focus with mod + arrow keys
        "SHIFT, left, movefocus, l"
        "SHIFT, right, movefocus, r"
        "SHIFT, up, movefocus, u"
        "SHIFT, down, movefocus, d"

        # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mod + SHIFT + [0-9]
        "$mod2 , 1, movetoworkspace, 1"
        "$mod2 , 2, movetoworkspace, 2"
        "$mod2 , 3, movetoworkspace, 3"
        "$mod2 , 4, movetoworkspace, 4"
        "$mod2 , 5, movetoworkspace, 5"
        "$mod2 , 6, movetoworkspace, 6"
        "$mod2 , 7, movetoworkspace, 7"
        "$mod2 , 8, movetoworkspace, 8"
        "$mod2 , 9, movetoworkspace, 9"
        "$mod2 , 0, movetoworkspace, 10"


        # Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mod + scroll
        "$mod2, right, workspace, +1"
        "$mod2, left, workspace, -1"
        "$mod, right, movetoworkspace, +1"
        "$mod, left, movetoworkspace, -1"

        #touch_grass plugins config
        #" , edge:r:l, workspace, +1"
        #" , edge:l:r, workspace, -1"
        " , edge:l:r, exec, $menu"
        " , edge:r:l, exec, $terminal"
        " , edge:d:u, togglespecialworkspace, magic"
        " , swipe:3:u, exec, wvkbd-mobintl &"
        " , swipe:3:d, exec, pkill wvkbd-mobintl"
        " , swipe:3:r, exec, workspace +1"
        " , swipe:3:l, exec, workspace -1"
        " , swipe:4:r, exec, movetoworkspace +1"
        " , swipe:4:l, exec, movetoworkspace -1"
        " , swipe:4:d, killactive"
      ];
# Move/resize windows with mod + LMB/RMB and dragging
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"

        #touch_grass plugins config
        " , longpress:3, movewindow"
        " , longpress:2, resizewindow"
      ];
    };
  };
}
