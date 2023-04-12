# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
    imports = [ # Include the results of the hardware scan. 

   <nixos-hardware/lenovo/thinkpad/t420>
    ./hardware-configuration.nix
   <home-manager/nixos>
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = false;
  boot.loader.systemd-boot.configurationLimit = 16;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Optimising the store 
  nix.settings.auto-optimise-store = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable grub cryptodisk
  boot.loader.grub.enableCryptodisk = true;

   boot.initrd.luks.devices."luks-11e71207-892a-4df2-880a-455840815c06".keyFile = "/crypto_keyfile.bin";
  # Enable swap on luks
  boot.initrd.luks.devices."luks-be1fc65c-7d98-4d49-91f0-d447d2c84efd".device = "/dev/disk/by-uuid/be1fc65c-7d98-4d49-91f0-d447d2c84efd";
  boot.initrd.luks.devices."luks-be1fc65c-7d98-4d49-91f0-d447d2c84efd".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "shadowking"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #services.resolved.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  # Enable Self-host Adblock
  services.adguardhome = {
  enable = true;
  };
  
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true; 

  # Enable the KDE Plasma Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "br";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable Bluetooth support 
  hardware.bluetooth.enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tr3nts = {
    isNormalUser = true;
    description = "tr3nts";
    extraGroups = [ "networkmanager" "wheel"];
    packages = with pkgs; [
      firefox
    # thunderbird
    ];
  };

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
  elisa
 ];

  # Allow unfree packages
   nixpkgs.config.allowUnfree = true;
	
  home-manager.useGlobalPkgs = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # }; 
  
  #nix.settings.experimental-features = [ "nix-command" "flakes" ];
   #nix.package = pkgs.nixUnstable;
  # nix.extraOptions = ''
 # experimental-features = nix-command flakes
#'';

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = true;
  # networking.firewall.allowPing = false;

  services.opensnitch = {
  enable = true;
  };  
 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

   home-manager.users.tr3nts = { pkgs, ... }: {
      home.packages = with pkgs; [ adguardhome lego certbot nginxMainline thunderbird librewolf keepassxc ksystemlog plasma-workspace plasma-integration tdesktop element-desktop konversation onlyoffice-bin helix remmina valgrind htop libva lsof firejail nixfmt opensnitch-ui vulnix qt6.qtwebengine qt6.full qt6.qtbase qt6.qtwayland mesa mesa-demos nano gst_all_1.gst-vaapi git neofetch cbonsai asciiquarium cowsay nmap nextcloud-client wireshark noto-fonts noto-fonts-cjk-sans noto-fonts-emoji cmatrix curl oneko fortune figlet pfetch zlib sl ffmpeg_5-full mixxx mpv cargo nodejs vlc youtube-dl czkawka microcodeIntel vaapi-intel-hybrid opencl-headers python311 intel-ocl libdrm x265 wget2 tldr exa duf vlc qbittorrent glibc libde265 gparted gnutar unzip kate lm_sensors vscodium discord chromium ];
      programs.bash.enable = true;
      home.stateVersion = "21.11";

  };

}

 
