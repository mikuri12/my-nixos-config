{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
       ./sddm.nix
   #   ./kde.nix
   #   ./gnome.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
 
  networking.networkmanager.enable = true;

  time.timeZone = "America/peruyork";

  i18n.defaultLocale = "es_GT.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_GT.UTF-8";
    LC_IDENTIFICATION = "es_GT.UTF-8";
    LC_MEASUREMENT = "es_GT.UTF-8";
    LC_MONETARY = "es_GT.UTF-8";
    LC_NAME = "es_GT.UTF-8";
    LC_NUMERIC = "es_GT.UTF-8";
    LC_PAPER = "es_GT.UTF-8";
    LC_TELEPHONE = "es_GT.UTF-8";
    LC_TIME = "es_GT.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
 #  services.printing.enable = true;
 

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  
  };


  users.users.mikuri = {
    isNormalUser = true;
    description = "mikuri";
    extraGroups = [ "networkmanager" "wheel" "lp" "scanner" "gamemode" "podman"  ];
    packages = with pkgs; [
  
    ];
  };
  # esto es opcional ya que la configuracion de niri te lo agrega
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
 
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gnome" "gtk" ];
      };
      niri = {
        default = [ "gnome" "gtk" ];
      };
    };
  };

  hardware.graphics = {
          enable = true;
                 extraPackages = with pkgs; [
        libva
       # whatever va and other drivers ur gonna use 
      ];
   };
  programs.dconf.enable = true;
  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; 
  dedicatedServer.openFirewall = true; 
  localNetworkGameTransfers.openFirewall = true; 
  };
  services.fwupd.enable = true; 
  services.flatpak.enable = true ;   
  programs.firefox.enable = true; 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.niri.enable = true; 
  programs.gamemode.enable = true;
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  nixpkgs.config.allowUnfree = true;
  
  # woooooooAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa
  
  environment.systemPackages = with pkgs; [  
   pkgs.vscodium
   pkgs.gamescope
   #pkgs.gpu-screen-recorder-gtk
   pkgs.xdg-desktop-portal-gnome
   pkgs.gpu-screen-recorder
   kdePackages.layer-shell-qt
   pkgs.libsForQt5.qt5.qtmultimedia
   pkgs.kdePackages.qtbase
   pkgs.kdePackages.qtwayland
   pkgs.yazi
   pkgs.yt-dlp 
   #pkgs.kdePackages.dolphin
   pkgs.xdg-desktop-portal-gtk 
    noto-fonts
    noto-fonts-color-emoji
    hack-font
     pkgs.kdePackages.breeze
    pkgs.kdePackages.breeze-gtk
    pkgs.kdePackages.breeze-icons
   #pkgs.kdePackages.qqc2-desktop-style
   #pkgs.kdePackages.qtstyleplugin-kvantum
   #kdePackages.kirigami-addons
   #pkgs.libsForQt5.kirigami2
   #pkgs.kdePackages.kirigami
   pkgs.xdg-desktop-portal-wlr 
   pkgs.kdePackages.qtmultimedia
   papirus-icon-theme
   pkgs.nautilus
   pkgs.spicetify-cli
   pkgs.spotify
   pkgs.xdg-desktop-portal
   pkgs.p7zip
   pkgs.unrar
   pkgs.heroic 
   pkgs.lutris
   pkgs.wineWowPackages.stagingFull
   pkgs.xorg.xvfb
   starship
   glib 
   pkgs.fwupd
   gnome-software
   pkgs.kdePackages.ark
   pkgs.cliphist
   niri
   pkgs.dbus
   pkgs.xwayland-satellite
   vulkan-tools
   wl-clipboard
   wayland-utils
   mesa 
   fish
   brave
   cava
   nitch
   # xfce.thunar
   niri
   flatpak
   git
   fastfetch 
   vim
   vesktop
   wget
   pkgs.cemu
   dconf
   libsForQt5.qt5ct
   kdePackages.qt6ct
   kdePackages.qtwayland
   gsettings-qt 
   nwg-look 
   gsettings-desktop-schemas
   xsettingsd 
   gtk-engine-murrine 
   adwaita-icon-theme
   material-symbols
   adw-gtk3
   morewaita-icon-theme

  ];
  boot.plymouth = {
            enable = true;

            themePackages = [ pkgs.mikuboot ];
            theme = "mikuboot";
 
    };

  system.stateVersion = "25.05";     

}

