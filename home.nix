{config, pkgs, ...}: {
  imports = [
    #./hyprland/hyprdot.nix
    #./gnome/gnome-dot.nix
  ];
  /* The home.stateVersion option does not have a default and must be set */
  programs.home-manager.enable = true;
  /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  home.packages = with pkgs; [
    gcc
    luajit
    gnome.adwaita-icon-theme
    papirus-icon-theme
  ];
  # Bluetooth media controls
  /*
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

    home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Amber";
    size = 28;
  };

*/
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
      #package = pkgs.gnome.gnome-themes-extra;
      #name = "Adwaita-dark";
    };
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
      #name = "Adwaita";
      #package = pkgs.gnome.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "NieR Cursors";
      #package = (pkgs.callPackage ./nier_cursor.nix {});
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
    htop = {
      enable = true;
      settings = {
        color_scheme = 6;
        cpu_count_from_one = 0;
        delay = 5;
        show_program_path=0;
        hide_kernel_threads=1;
        highlight_deleted_exe=1;
        highlight_megabytes=1;
        highlight_threads=1;
        find_comm_in_cmdline=1;
        strip_exe_from_cmdline=1;
        header_margin=1;
        screen_tabs=1;
        show_cpu_usage=1;
        show_cpu_frequency=1;
        show_cpu_temperature=1;
        tree_view=1;
        sort_direction=-1;
        tree_sort_direction=-1;
        tree_view_always_by_pid=0;
        
        fields = with config.lib.htop.fields; [
          PID
          USER
          PRIORITY
          NICE
          M_SHARE
          STATE
          M_SWAP
          PERCENT_MEM
          M_RESIDENT
          PERCENT_CPU
          TIME
          COMM
        ];
        highlight_base_name = 1;
      } // (with config.lib.htop; leftMeters [
        (bar "AllCPUs4")
        (bar "CPU")
        (bar "Memory")
        (bar "Swap")
        (bar "HugePages")
      ]) // (with config.lib.htop; rightMeters [
        (text "Tasks")
        (text "LoadAverage")
        (text "Uptime")
        (text "Battery")
        (text "DiskIO")
        (text "NetworkIO")
        (text "MemorySwap")
      ]);
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  xdg.configFile = {
    "nvim/" = {
      source = (pkgs.callPackage ./packages/nvchad/default.nix{}).nvchad;
    };
    "neofetch/config.conf" = {
      text = ''
        print_info() {
          prin "┌──────────────────────\n User Information \n──────────────────────┐"
          info "\n \n $(color 7)├$(color 6) Users  " users 
          prin "├────────────────────\n Terminal Information \n────────────────────┤"    
          info "\n \n $(color 7)├$(color 6) Shell  " shell
          info "\n \n $(color 7)├$(color 6) Terminal  " term
          info "\n \n $(color 7)├$(color 6) Terminal-Font  " term_font
          prin "├────────────────────\n Hardware Information \n────────────────────┤"
          info "\n \n $(color 7)├$(color 6) Model 󰌢 " model
          info "\n \n $(color 7)├$(color 6) CPU 󰍛 " cpu
          info "\n \n $(color 7)├$(color 6) GPU 󰘚 " gpu
          prin "├────────────────────\n Software Information \n────────────────────┤"
          info "\n \n $(color 7)├ $(color 6)Distro  " distro
          info "\n \n $(color 7)├ $(color 6)Kernel  " kernel
          info "\n \n $(color 7)├ $(color 6)Windows-Manager  " wm
          info "\n \n $(color 7)├ $(color 6)Packages 󰊠 " packages 
        #  info "\n \n $(color 7)├ $(color 6)Playing 󰝚 " song
          info "\n \n $(color 7)├ $(color 6)Local IP  " local_ip
        #  info " ​ ​   " public_ip
        #    info " ​ ​   " locale  # This only works on glibc systems.
            prin "└──────────────────────────────────────────────────────────────┘"
        #    info cols
        prin "\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n $(color 0) \n \n $(color 1) \n \n $(color 2) \n \n $(color 3)  \n \n $(color 4)  \n \n $(color 5)  \n \n $(color 6)  \n \n $(color 7) "
        prin "\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n $(color 8) \n \n $(color 9) \n \n $(color 10) \n \n $(color 11) \n \n $(color 12) \n \n $(color 13) \n \n $(color 14) \n \n $(color 15) "
        }
      '';
      };
    };
  home.file.".local/share/PrismLauncher/accounts.json" = {
    text = ''
      {
        "accounts": [
          {
            "profile": {
              "capes": [],
              "id": "ddbecf10c5753f2a88a50f839c44de6b",
              "name": "Kahlenden",
              "skin": {
                "id": "",
                "url": "",
                "variant": ""
              }
            },
            "type": "Offline",
              "ygg": {
                "extra": {
                  "clientToken": "7e9fa15cda0444b3a75ac174e2353bbb",
                  "userName": "Kahlenden"
                },
                "iat": 1704500826,
                "token": "0"
              }
            }
        ],
        "formatVersion": 3
      }
    '';
  };

  #xmrig
#  services.xmrig = {
#  enable = true;
#  settings = {
#    autosave = true;
#    cpu = true;
#    opencl = false;
#    cuda = false;
#    donation-level = 1;
#    pools = [
#      {
#        url = "127.0.0.1:3333";
#        user = "43kBcSCrm7xBiqDTAY8CMKg5DugrraDBk5Cj2ffWzhd99iLkLgM1crXNCgp2sjLxq4LWTRivc7kcWfWPhcxa4qRZ17sCCZA";
#        keepalive = true;
#        tls = true;
#      }
#    ];
#  };
#};
#};
}
