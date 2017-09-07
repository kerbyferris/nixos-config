# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/mmcblk0";

  networking = {
    hostName = "nixos"; # Define your hostname.
    # networkmanager.enable = true;
    wireless.enable = true;
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    ansible
    chromium
    curl
    dmenu
    dzen2
    docker
    emacs
    file
    gitAndTools.gitFull
    gnupg
    htop
    neovim
    perl
    python
    rxvt_unicode
    # stalonetray
    tmux
    tree
    vagrant
    vim
    vlc
    xterm
    wget
  ] ++ (with haskellPackages; [
    ghc
    xmobar
  ]);

  nixpkgs.config = {
    allowUnfree = true;

    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };

  programs = {
    bash.enableCompletion = true;
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  # List services that you want to enable:
  services.nixosManual.showManual = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    layout = "us";
    synaptics = {
      enable = true;
      twoFingerScroll = true;
      horizontalScroll = false;
      palmDetect = true;
      buttonsMap = [ 1 3 2 ];
      tapButtons = false;
      additionalOptions = ''
        Option "VertScrollDelta" "-180"
        Option "HorizScrollDelta" "-180"
        Option "disableWhileTyping" "true"
        '';
    };

    # Enable a Desktop Environment.
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
            haskellPackages.xmonad-contrib
            haskellPackages.xmonad-extras
            haskellPackages.xmonad
        ];
      };
      default = "xmonad";
    };

    displayManager = {
      slim.enable = true;
      auto = {
        enable = true;
        user = "barbara";
      };
      sessionCommands = ''
        ${pkgs.xlibs.xmodmap}/bin/xmodmap ~/.Xmodmap 
        ${pkgs.xlibs.xrdb}/bin/xrdb -merge ~/.Xresources 
      '';
    };
  };

  # Define a user account.
  users.extraUsers.barbara = {
    name = "barbara";
    group = "users";
    extraGroups = [
      "wheel" "disk" "audio" "video"
      "networkmanager"
    ];
    createHome = true;
    uid = 1000;
    home = "/home/barbara";
    shell = "/run/current-system/sw/bin/bash";
  };

  security.sudo.enable = true;
  security.sudo.configFile = "barbara ALL=(ALL) NOPASSWD: ALL";

  # Audio
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.extraConfig = ''
    load-module module-switch-on-connect
    '';

  powerManagement.enable = true;

  fonts = {
      enableCoreFonts = true;
      enableFontDir = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
          anonymousPro
          corefonts
          dejavu_fonts
          emojione
          freefont_ttf
          nerdfonts
          liberation_ttf
          powerline-fonts
          source-code-pro
          terminus_font
          ttf_bitstream_vera
          ubuntu_font_family
      ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
