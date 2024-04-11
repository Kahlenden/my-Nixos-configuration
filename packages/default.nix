{pkgs, ...}:
{
#  imports = [ ./vscodium ];
  services.flatpak.enable = true;
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      #"electron-19.1.9"
    ];
  };

  environment.systemPackages = with pkgs; [
    # Custom scripts
    backup restore

    # Coding
    python311 jdk nodejs
    nodePackages.typescript-language-server
    bun # for building typescript
    dart-sass
    fd


    # for https://github.com/Beinsezii/NieR-Cursors
    xorg.xcursorgen bc blender
    nwg-look

    # Terminal utils
    coreutils findutils pciutils inetutils
    htop tree neofetch lolcat curl wget intel-gpu-tools unzip neovim jq crudini ascii
    gptfdisk cryptsetup efibootmgr
    kitty kitty-themes
    
    # Necessities
    (qt6Packages.callPackage ./caesium{}) # image compressor
    gnome.gnome-font-viewer
    gnome.gnome-disk-utility
    qbittorrent # Torrent client
    libreoffice # Office
    keepassxc # Password manager
    ollama # Artificial Intelligent
    czkawka # file duplication romover
    polkit_gnome # Graphical sudo
    
    # Browsers
    brave mullvad-browser librewolf
    mullvad-vpn

    # Networking stuffs
    gns3-server dynamips ubridge vpcs wireshark
     
    # Monero
    monero-gui monero-cli xmrig p2pool
    
    # Games 
    lutris wineWowPackages.waylandFull
    prismlauncher # Minecraft

    # Work
    git gh
    super-productivity
    
    # Apps
    thunderbird freetube discord signal-desktop teams-for-linux
    
    # Music
    songrec youtube-music amberol spotube 
    # Media related
    loupe vlc pavucontrol obs-studio shotcut

    # GPU benchmarking
    unigine-superposition unigine-valley

    # fish plugins
    fishPlugins.done
    fishPlugins.fzf-fish fzf
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.grc grc
    fishPlugins.autopair
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  
  nixpkgs.overlays = [(self: super: { 
    backup = pkgs.pkgs.writeShellScriptBin "backup" '' 
      #!/run/current-system/sw/bin/bash

      # Initialize flags
      flag_n=false
      flag_h=false
      flag_v=false
      
      # Function to display usage information
      usage() {
          echo -e "Usage: $0 \e[31m[-n NEED sudo]\e[0m [-h] \e[31m[-v NEED sudo]\e[0m [-a]" >&2
          echo -e "  -n    nixos backup \e[31m[REQUIRES SUDO]\e[0m"
          echo    "  -h    /home backup"
          echo -e "  -v    vm images (libvirtd) backup \e[31m[REQUIRES SUDO]\e[0m"
          echo -e "  -a    Activate all flags \e[31m[REQUIRES SUDO]\e[0m"
          exit 1
      }

      # Check if no options provided
      if [ $# -eq 0 ]; then
        usage
      fi

      # check if backup disk exists
      disk=$(df -h | grep '/run/media/' | awk '{print $NF}')
      if [ -z "$disk" ]; then
        echo "Default backup disk not found. (usually at /run/media/<user>/<disk>)"
        while true; do
          read -p "   Please enter another path to backup: " disk
          echo -e "   Is \e[32m$disk\e[0m your backup location? (yes/no)"
          read confirmation
          if [ "$confirmation" == "yes" ] || [ "$confirmation" == "no" ]; then
            if [[ $confirmation == "yes" ]]; then
              break
            fi
          else
            echo "ONLY yes or no"
          fi
        done
      else 
        while true; do
          echo -e "   Is \e[32m$disk\e[0m your backup location? (yes/no)"
          read confirmation
          if [ "$confirmation" == "yes" ] || [ "$confirmation" == "no" ]; then
            if [[ $confirmation == "yes" ]]; then
              break
            else
              read -p "   Please enter another path to backup location: " disk
            fi
          else
            echo "ONLY yes or no"
          fi
        done
      fi

      # mkdir backup if doesnt exist
      mkdir -p "$disk"/Back_Up
      
      # Parse command line options
      while getopts ":nhva" option; do
        case $option in
          n)
            # Check if sudo is used
            if [ "$(id -u)" != "0" ]; then
              echo -e "\e[31mError: -n flag requires sudo.\e[0m"
              usage
            fi
            flag_n=true
            ;;
          h)
            user_check=$(ls -l /home | awk '/^d/ {print $NF}')

            # Check if there's only one user directory
            if [ $(echo "$user_check" | wc -l) -eq 1 ]; then
              username=$user_check
            else
              # If there are multiple directories, prompt the user to select a username
              echo "Multiple user directories found in /home:"
              while true; do
                select username in $user_check; do
                  if [ -n "$username" ]; then
                    echo -e "Will back up \e[32m/home/$username\e[0m"
                    break 2
                  else
                    echo -e "\e[31mInvalid selection. Please choose a number from the list.\e[0m"
                  fi
                done
              done
            fi
            flag_h=true
            ;;
          v)
            # Check if sudo is used
            if [ "$(id -u)" != "0" ]; then
              echo -e "\e[31mError: -v flag requires sudo.\e[0m"
              usage
            fi
            flag_v=true
            ;;
          a)
            # Check if sudo is used
            if [ "$(id -u)" != "0" ]; then
              echo -e "\e[31mError: -a flag requires sudo.\e[0m"
              usage
            fi
            user_check=$(ls -l /home | awk '/^d/ {print $NF}')

            # Check if there's only one user directory
            if [ $(echo "$user_check" | wc -l) -eq 1 ]; then
              username=$user_check
            else
              # If there are multiple directories, prompt the user to select a username
              echo "Multiple user directories found in /home"
              echo "Choose one of the below to backup:"
              while true; do
                select username in $user_check; do
                  if [ -n "$username" ]; then
                    echo -e "Will back up \e[32m/home/$username\e[0m"
                    break 2
                  else
                    echo "Invalid selection. Please choose a number from the list."
                  fi
                done
              done
            fi
            flag_n=true
            flag_h=true
            flag_v=true
            ;;
          *)
            usage
            ;;
        esac
      done
      
      # Output based on flags
      if $flag_n; then
        rsync -hiva --exclude='hardware-configuration.nix' --delete-excluded --delete /etc/nixos "$disk"/Back_Up/
      fi
      if $flag_h; then
        # List all the files/dir you wish to backup below, or just /home/"$username", but it will be inefficient and slow
        rsync -hiva --delete --relative \
          /home/"$username"/Public \
          /home/"$username"/Documents \
          /home/"$username"/Downloads \
          /home/"$username"/Music \
          /home/"$username"/Pictures \
          /home/"$username"/Videos \
          /home/"$username"/Games \
          /home/"$username"/.bitmonero \
          /home/"$username"/Monero \
          /home/"$username"/config.json \
          /home/"$username"/p2pool.log \
          /home/"$username"/p2pool.cache \
          /home/"$username"/p2pool_peers.txt \
          /home/"$username"/keepass.kdbx \
          /home/"$username"/VirtualBox\ VMs \
          /home/"$username"/.local/share/fonts \
          /home/"$username"/.local/share/qBittorrent/BT_backup \
          /home/"$username"/.config/qBittorrent \
          /home/"$username"/.config/GNS3 \
          /home/"$username"/GNS3 \
          /home/"$username"/.icons \
        "$disk"/Back_Up/
      fi
      if $flag_v; then
        rsync -hiva --delete /var/lib/libvirt/images/  "$disk"/Back_Up/vm-backup/images/
      fi

      exit 0 
    '';
    restore = pkgs.pkgs.writeShellScriptBin "restore" ''
      #!/run/current-system/sw/bin/bash

      # Initialize flags
      flag_n=false
      flag_h=false
      flag_v=false

      # Function to display usage information
      usage() {
        echo -e "Usage: $0 [-n] [-h] \e[31m[-v NEED sudo]\e[0m [-a]" >&2
        echo -e "  -n    restore nixos configuration \e[31m[REQUIRES SUDO]\e[0m"
        echo    "  -h    restore /home"
        echo -e "  -v    restore vm images (libvirtd) \e[31m[REQUIRES SUDO]\e[0m"
        echo -e "  -a    Activate all flags \e[31m[REQUIRES SUDO]\e[0m"
        exit 1
      }

      # Check if no options provided
      if [ $# -eq 0 ]; then
        usage
      fi
     
      # check if backup disk exists
      disk=$(df -h | grep '/run/media/' | awk '{print $NF}')
      if [ -z "$disk" ]; then
        echo "Default backup disk not found. (usually at /run/media/<user>/<disk>)"
        while true; do
          read -p "   Please enter another path to backup: " disk
          echo -e "   Is \e[32m$disk\e[0m your backup location? (yes/no)"
          read confirmation
          if [ "$confirmation" == "yes" ] || [ "$confirmation" == "no" ]; then
            if [[ $confirmation == "yes" ]]; then
              break
            fi
          else
            echo "ONLY yes or no"
          fi
        done
      else 
        while true; do
          echo -e "   Is \e[32m$disk\e[0m your backup location? (yes/no)"
          read confirmation
          if [ "$confirmation" == "yes" ] || [ "$confirmation" == "no" ]; then
            if [[ $confirmation == "yes" ]]; then
              break
            else
              read -p "   Please enter another path to backup location: " disk
            fi
          else
            echo "ONLY yes or no"
          fi
        done
      fi

      # Parse command line options
      while getopts ":nhva" option; do
        case $option in
          n)
            # Check if sudo is used
            if [ "$(id -u)" != "0" ]; then
              echo -e "\e[31mError: -n flag requires sudo.\e[0m"
              usage
            fi
            flag_n=true
            ;;
          h)
            # Identify username (to restore to/home/$username/)
            user_check=$(ls -l /home | awk '/^d/ {print $NF}')

            # Check if there's only one user directory
            if [ $(echo "$user_check" | wc -l) -eq 1 ]; then
              username=$user_check
            else
              # If there are multiple directories, prompt the user to select a username
              echo "Multiple user directories found in /home:"
              echo "Wich user home dir do you want to restore?"
              while true; do
                select username in $user_check; do
                  if [ -n "$username" ]; then
                    if [ ! -e "$disk/Back_Up/home/$username" ]; then
                      echo -e "\e[31mERROR: backup for user \e[32m$username\e[31m does not exist\e[0m"
                      exit 1
                    fi
                    echo -e "Will restore from \e[32m$disk/Back_Up/home/$username\e[0m to \e[32m/home/$username\e[0m"
                    break 2
                  else
                    echo "Invalid selection. Please choose a number from the list."
                  fi
                done
              done
            fi
            flag_h=true
            ;;
          v)
            # Check if sudo is used
            if [ "$(id -u)" != "0" ]; then
                echo -e "\e[31mError: -v flag requires sudo.\e[0m"
                usage
            fi
            flag_v=true
            ;;
          a)
            # Check if sudo is used
            if [ "$(id -u)" != "0" ]; then
                echo -e "\e[31mError: -a flag requires sudo.\e[0m"
                usage
            fi
            user_check=$(ls -l /home | awk '/^d/ {print $NF}')

            # Check if there's only one user directory
            if [ $(echo "$user_check" | wc -l) -eq 1 ]; then
              username=$user_check
            else
              # If there are multiple directories, prompt the user to select a username
              echo "Multiple user directories found in /home:"
              while true; do
                select username in $user_check; do
                  if [ -n "$username" ]; then
                    echo -e "Will restore from \e[32m$disk/Back_Up/home/$username\e[0m to \e[32m/home/$username\e[0m"
                    break 2
                  else
                    echo -e "\e[31mInvalid selection. Please choose a number from the list.\e[0m"
                  fi
                done
              done
            fi
            flag_n=true
            flag_h=true
            flag_v=true
            ;;
          *)
            usage
            ;;
        esac
      done

      # Output based on flags
      if $flag_n; then
        rsync -hiva --exclude='hardware-configuration.nix' "$disk"/Back_Up/nixos/ /etc/nixos/
      fi
      if $flag_h; then
        rsync -hiva "$disk"/Back_Up/home/"$username"/ /home/"$username"/
      fi
      if $flag_v; then
        rsync -hiva "$disk"/Back_Up/vm-backup/images/ /var/lib/libvirt/images/
      fi

      exit 0
    '';
  })];
}
