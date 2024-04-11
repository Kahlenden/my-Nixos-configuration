{inputs, username, config, lib, pkgs, ...}:
let
  xmr = pkgs.pkgs.writeShellScriptBin "xmr" ''
  curl -X 'GET' \
    'https://api.coingecko.com/api/v3/simple/price?ids=monero&vs_currencies=CAD&precision=1' \
    -H 'accept: application/json' | \
    jq .monero.cad
  '';
in 
{
  programs.waybar = {
    enable = true;
    style = ''
* {
    font-family: FiraCode , Noto Sans,FontAwesome, Roboto, Helvetica, Arial, sans-serif;
    font-size: 15px;
    font-weight: bolder;
}
#custom-xmrPrice, #custom-xmrPriceIcon,
#mpris,
#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#custom-media,
#tray,
#mode,
#idle_inhibitor,
#custom-expand,
#custom-cycle_wall,
#custom-ss,
#custom-dynamic_pill,
#workspaces,
#mpd {
    border-radius: 15px;
    background: #11111b;
    color: #b4befe;
    box-shadow: rgba(0, 0, 0, 0.116) 2 2 5 2px;
    margin-top: 5px;
    margin-bottom: 10px;
    margin-right: 10px;
}

window#waybar {
    background-color: transparent;
}

#custom-dynamic_pill label {
    color: #11111b;
    font-weight: bold;
}

#custom-dynamic_pill.paused label {
    color: 	#89b4fa ;
}

#workspaces button label{
    color: 	#89b4fa ;
}

#workspaces button.active label{
    color: #11111b;
}

#workspaces{
    background: #cad3f5;
    padding-top: 3px;
    padding-bottom: 3px;
    padding-right: 20px;
    padding-left: 20px;
    border-radius: 15px;
}
#workspaces button{
    box-shadow: rgba(0, 0, 0, 0.116) 2 2 5 2px;
    background-color: #11111b ;
    border-radius: 15px;
    margin-right: 10px;
    padding: 10px;
    padding-top: 2px;
    padding-bottom: 2px;
    padding-right: 10px;
    padding-left: 10px;
    color: 	#89b4fa ;
    transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.68);
}

#workspaces button.active{
    padding-right: 20px;
    box-shadow: rgba(0, 0, 0, 0.288) 2 2 5 2px;
    padding-left: 20px;
    padding-bottom: 3px;
    background: rgb(203,166,247);
    background: radial-gradient(circle, rgba(203,166,247,1) 0%, rgba(193,168,247,1) 12%, rgba(249,226,175,1) 19%, rgba(189,169,247,1) 20%, rgba(182,171,247,1) 24%, rgba(198,255,194,1) 36%, rgba(177,172,247,1) 37%, rgba(170,173,248,1) 48%, rgba(255,255,255,1) 52%, rgba(166,174,248,1) 52%, rgba(160,175,248,1) 59%, rgba(148,226,213,1) 66%, rgba(155,176,248,1) 67%, rgba(152,177,248,1) 68%, rgba(205,214,244,1) 77%, rgba(148,178,249,1) 78%, rgba(144,179,250,1) 82%, rgba(180,190,254,1) 83%, rgba(141,179,250,1) 90%, rgba(137,180,250,1) 100%);
    background-size: 400% 400%;
    /*animation: gradient_f 20s ease-in-out infinite;*/
    transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
}

@keyframes gradient {
	0% {
		background-position: 0% 50%;
	}
	50% {
		background-position: 100% 30%;
	}
	100% {
		background-position: 0% 50%;
	}
}

@keyframes gradient_f {
	0% {
		background-position: 0% 200%;
	}
    50% {
        background-position: 200% 0%;
    }
	100% {
		background-position: 400% 200%;
	}
}

@keyframes gradient_f_nh {
	0% {
		background-position: 0% 200%;
	}
	100% {
		background-position: 200% 200%;
	}
}

#clock {
    background: rgb(137,180,250);
    background: radial-gradient(circle, rgba(137,180,250,120) 0%, rgba(142,179,250,120) 6%, rgba(148,226,213,1) 14%, rgba(147,178,250,1) 14%, rgba(155,176,249,1) 18%, rgba(245,194,231,1) 28%, rgba(158,175,249,1) 28%, rgba(181,170,248,1) 58%, rgba(205,214,244,1) 69%, rgba(186,169,248,1) 69%, rgba(195,167,247,1) 72%, rgba(137,220,235,1) 73%, rgba(198,167,247,1) 78%, rgba(203,166,247,1) 100%); 
    background-size: 400% 400%;
    /*animation: gradient_f 30s cubic-bezier(.72,.39,.21,1) infinite;*/
    text-shadow: 0 0 5px rgba(0, 0, 0, 0.5);
    color: #232634;
    
    padding-top: 2px;
    padding-bottom: 2px;
    padding-right: 20px;
    padding-left: 20px;
}

#battery.charging, #battery.plugged {
    border: 3px solid #a6e3a1;
}

#battery {
    margin-right: 20px;
}

@keyframes blink {
    to {
        background-color: #f9e2af;
        color:#96804e;
    }
}



#battery.critical:not(.charging) {
    border: 2px solid red;
    background-color: #f38ba8;
    color: #bf5673;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

#cpu label{
    color:#89dceb;
}

#custom-xmrPrice,
#temperature,
#battery,
#network.wifi, #network.ethernet,
#pulseaudio,
#disk,
#memory, 
#cpu {
    padding-left: 7px;
    padding-right: 7px;
    background: rgb(30,30,46);
    color: 	#89b4fa; 
    margin-left: 0;
    margin-right: 0;
    border-radius: 15px 0 0 15px;
}
#custom-xmrPriceIcon,
#temperature.icon,
#battery.icon,
#network.icon,
#pulseaudio.icon,
#disk.icon,
#memory.icon,
#cpu.icon {
    min-height: 36px;
    min-width: 36px;
    background: rgb(137,180,250);
    background: radial-gradient(circle, rgba(137,180,250,120) 0%, rgba(142,179,250,120) 6%, rgba(148,226,213,1) 14%, rgba(147,178,250,1) 14%, rgba(155,176,249,1) 18%, rgba(245,194,231,1) 28%, rgba(158,175,249,1) 28%, rgba(181,170,248,1) 58%, rgba(205,214,244,1) 69%, rgba(186,169,248,1) 69%, rgba(195,167,247,1) 72%, rgba(137,220,235,1) 73%, rgba(198,167,247,1) 78%, rgba(203,166,247,1) 100%); 
    background-size: 400% 400%;
    /*animation: gradient_f 30s cubic-bezier(.72,.39,.21,1) infinite;*/
    color: #232634;
    padding: 0;
    border-radius: 0 15px 15px 0;
    margin-right: 10px;
    font-size: 17px;
}

#custom-xmrPrice,
#network.wifi, #network.ethernet {
  border-radius: 0 15px 15px 0;
}

#custom-xmrPriceIcon,
#network.icon {
  border-radius: 15px 0 0 15px;
  margin-right: 0;
}

#custom-xmrPriceIcon {
  margin-left: 10px;
}

#tray {
  background: rgb(30,30,46);
  color: 	#89b4fa; 
  padding-left: 10px;
  padding-right: 10px;
}

#backlight {
    color: #90b1b1;
}

#network{
    color: 	#000;
}

#network.disabled{
    background-color: #45475a;
}

#network.disconnected{
    background: rgb(243,139,168);
    background: linear-gradient(45deg, rgba(243,139,168,1) 0%, rgba(250,179,135,1) 100%); 
    color: #fff;
    padding-top: 3px;
    padding-right: 11px;
}
#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: #eb4d4b;
}
#mpris {
    background: rgb(137,180,250);
    background: radial-gradient(circle, rgba(137,180,250,120) 0%, rgba(142,179,250,120) 6%, rgba(148,226,213,1) 14%, rgba(147,178,250,1) 14%, rgba(155,176,249,1) 18%, rgba(245,194,231,1) 28%, rgba(158,175,249,1) 28%, rgba(181,170,248,1) 58%, rgba(205,214,244,1) 69%, rgba(186,169,248,1) 69%, rgba(195,167,247,1) 72%, rgba(137,220,235,1) 73%, rgba(198,167,247,1) 78%, rgba(203,166,247,1) 100%); 
    background-size: 400% 400%;
    /*animation: gradient_f 50s cubic-bezier(.72,.39,.21,1) infinite;*/
    color: #232634;
    padding: 0;
    border-radius: 15px;
    padding-left: 20px;
    padding-right: 20px;
}
#mpris.next, #mpris.prev  {
  background: rgb(30,30,46);
  color: 	#89b4fa;
  min-height: 36px;
  min-width: 36px;
  padding: 0;
  border-radius: 100%;
}
    '';
    settings = {
      mainBar = {
        "layer" = "top"; # Waybar at top layer
        "position" = "top"; # Waybar position (top|bottom|left|right)
        "height" = 52; # Waybar height (to be removed for auto height)
        # "width" = 1280; // Waybar width
        "spacing" = 0; # Gaps between modules (4px)
        # Choose the order of the modules
        # "margin-left" =25;
        # "margin-right" =25;
        "margin-bottom" =-11;
        #"margin-top" =5;
        "modules-left" = ["hyprland/workspaces" "tray" "network#icon" "network" "custom/xmrPriceIcon" "custom/xmrPrice"];
        "modules-right" = ["pulseaudio" "pulseaudio#icon" "disk" "disk#icon" "memory" "memory#icon" "temperature" "temperature#icon" "cpu" "cpu#icon" "battery" "battery#icon"];
        "modules-center" = ["clock"];
        # Modules configuration

        "keyboard-state" = {
            "numlock" = true;
            "capslock" = true;
            "format" = "{name} {icon}";
            "format-icons" = {
                "locked" = "";
                "unlocked" = "";
            };
        };
        "hyprland/workspaces" = {
            "format" = "{icon}";
            "format-active" = " {icon} ";
            "on-click" = "activate";
             "format-icons" ={
                "active" = "";
		            "default" = "";
             };
            "persistent-workspaces" = {
              "*" = 3;
            };
        };
        "sway/mode" = {
            "format" = "<span style=\"italic\">{}</span>";
        };
        "mpd" = {
            "format" = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime =%M =%S}/{totalTime =%M =%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
            "format-disconnected" = "Disconnected ";
            "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
            "unknown-tag" = "N/A";
            "interval" = 2;
            "consume-icons" = {
                "on" = " ";
            };
            "random-icons" = {
                "off" = "<span color=\"#f53c3c\"></span> ";
                "on" = " ";
            };
            "repeat-icons" = {
                "on" = " ";
            };
            "single-icons" = {
                "on" = "1 ";
            };
            "state-icons" = {
                "paused" = "";
                "playing" = "";
            };
            "tooltip-format" = "MPD (connected)";
            "tooltip-format-disconnected" = "MPD (disconnected)";
        };
        "idle_inhibitor" = {
            "format" = "{icon}";
            "format-icons" = {
                "activated" = "";
                "deactivated" = "";
            };
        };
        "tray" = {
            "icon-size" = 21;
            "spacing" = 10;
        };
        "clock" = {
            # "timezone" = "America/New_York";
            #"tooltip-format" = "<big>{:%Y-%m-%d}</big>\n<tt><small>{calendar}</small></tt>";
          "interval" = 60;
          "format" = "{:%a,%I:%M-%p}";
          "max-length" = 25;
          "format-alt" = "{:%A, %B %d, %Y (%R)}";
	        "tooltip-format" = "<tt><small>{calendar}</small></tt>";
	        "calendar" = {
          	"mode"          = "year";
          	"mode-mon-col"  = 3;
          	"weeks-pos"     = "right";
          	"on-scroll"     = 1;
          	"on-click-right"= "mode";
          	"format" = {
          		"months"=     "<span color='#ffead3'><b>{}</b></span>";
          		"days"=       "<span color='#ecc6d9'><b>{}</b></span>";
          		"weeks"=      "<span color='#99ffdd'><b>W{}</b></span>";
          		"weekdays"=   "<span color='#ffcc66'><b>{}</b></span>";
          		"today"=      "<span color='#ff6699'><b><u>{}</u></b></span>";
          	};
          };
          "actions" = {
          	"on-click-right" = "mode";
          	"on-click-forward" = "tz_up";
          	"on-click-backward" = "tz_down";
          	"on-scroll-up" = "shift_up";
          	"on-scroll-down" = "shift_down";
          };
        };
        "cpu" = {
          "interval" =1;
          "format" = "{usage}";
        };
        "cpu#icon" = {
          "format" = " ";
        };
        "memory" = {
          "format" = "{used:0.1f} GB";
        };
        "memory#icon" = {
          "format" = "";
        };
        "temperature" = {
            "thermal-zone" = 8;
          # "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
          "critical-threshold" = 75;
          "format-critical" = "{temperatureC}°C";
          "format" = "{temperatureC}°C";
        };
        "temperature#icon" = {
          "format" = "";
        };
        "backlight" = {
            # "device" = "acpi_video1";
          "format" = "{percent}% {icon}";
          "format-icons" = ["" "" "" "" "" "" "" "" ""];
        };
        "battery" = {
          "bat" = "BAT0";
          "format" = "{capacity}";
        };
        "battery#icon" = {
          "format" = "{icon}";
          # "format-good" = ""; // An empty format will hide the module
          # "format-full" = "";
          "format-icons" = ["" "" "" "" ""];
        }; 
        "network" = {
          "interval" = 2;
            # "interface" = "wlp2*"; // (Optional) To force the use of this interface
          "format" = "{bandwidthDownBytes} 󰜮 {bandwidthUpBytes} 󰜷";
          "tooltip-format" = "via {gwaddr} {ifname}";
          "format-disconnected" = "";
        };
        "network#icon" = {
          "interval" = 60;
          "format-wifi" = "{icon} ";
          "format-ethernet" = "󰈀";
          #"format-linked" = "";
          "format-disconnected" = "󱚵";
          "tooltip-format" = "";
          "format-icons" = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        };
        "disk" = {
	        "interval" = 60;
	        "format" = "{specific_used:0.1f} GiB";
	        "unit" = "GiB";
	      };
        "disk#icon" = {
          "format" = "󰋊";
        };
        "pulseaudio" = {
            # "scroll-step" = 1; // %, can be a float
          "format" = "{volume}";
          "format-bluetooth" = "{volume}";
          "on-click" = "pavucontrol";
        };
        "pulseaudio#icon" = {
          "format" = "{icon}";
          "format-bluethooth" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" ""];
          };
          "on-click" = "pavucontrol";
          "ignored-sinks" = [
            "Alder Lake PCH-P High Definition Audio Controller HDMI / DisplayPort 1 Output" 
            "Alder Lake PCH-P High Definition Audio Controller HDMI / DisplayPort 2 Output" 
            "Alder Lake PCH-P High Definition Audio Controller HDMI / DisplayPort 3 Output"
          ];
        };
        "custom/xmrPrice" = {
          interval = 60;
          escape = true;
          exec = "${xmr}/bin/xmr";
          format = "{} $";
          tooltip-format = "XMR: {} CAD";
        };
        "custom/xmrPriceIcon" = {
          format = "󰰐";
          tooltip-format = "";
          #format = "XMR";
        };
        "custom/media" = {
          "format" = "{icon} {}";
          "return-type" = "json";
          "max-length" = 40;
          "format-icons" = {
            "spotify" = "";
            "default" = "🎜";
          };
          "escape" = true;
          "exec" = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null"; # Script in resources folder
            # "exec" = "$HOME/.config/waybar/mediaplayer.py --player spotify 2> /dev/null" // Filter player based on name
        };
      };
      playBar = {
        "layer" = "top"; # Waybar at top layer
        "position" = "bottom"; # Waybar position (top|bottom|left|right)
        "height" = 52; # Waybar height (to be removed for auto height)
        # "width" = 1280; // Waybar width
        "spacing" = 5; # Gaps between modules (4px)
        # Choose the order of the modules
        # "margin-left" =25;
        # "margin-right" =25;
        "margin-top" =-11;
        #"margin-top" =5;
        "modules-center" = ["mpris#prev" "mpris" "mpris#next"];

        "mpris" = {
	        "format" = "⏸ {artist} - {title}";
	        "format-paused" = "󰐊 {artist} - {title}";
          "format-stop" = "";
          "tooltip-format" = "";
          "on-click" = "playerctl play-pause";
        };
        "mpris#prev" = {
	        "format" = "󰒮";
          "format-stop" = "";
          "tooltip-format" = "";
	        "on-click" = "playerctl previous";
        };
        "mpris#next" = {
	        "format" = "󰒭";
          "format-stop" = "";
          "tooltip-format" = "";
	        "on-click" = "playerctl next";
        };
      };
    };
  };
}
