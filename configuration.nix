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

  boot.initrd.luks.devices."luks-c13e2cb8-b419-4cfd-a01a-381725aeca2f".keyFile = "/crypto_keyfile.bin";
  # Enable swap on luks
  boot.initrd.luks.devices."luks-4e127dc7-6161-4dda-b627-efea4607f6ed".device = "/dev/disk/by-uuid/4e127dc7-6161-4dda-b627-efea4607f6ed";
  boot.initrd.luks.devices."luks-4e127dc7-6161-4dda-b627-efea4607f6ed".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "pantalaimon"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # services.resolved.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
    # thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow Container Application Development 
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #];

 environment.gnome.excludePackages = with pkgs.gnome; [
    totem # video player
    epiphany # web browser
    geary # email application
    gnome-contacts # agenda application
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 9150  9050  3000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
   networking.firewall.enable = true;
   networking.firewall.allowPing = false;
 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

   #users.users.tr3nts.isNormalUser = true;
   home-manager.users.tr3nts = { pkgs, ... }: {
      home.packages = [ pkgs.atool pkgs.httpie pkgs.tor-browser-bundle-bin pkgs.librewolf pkgs.chromium pkgs.deltachat-desktop pkgs.tdesktop pkgs.bpytop pkgs.fish pkgs.onlyoffice-bin pkgs.libva pkgs.gnome.gnome-tweaks pkgs.nixfmt pkgs.onionshare-gui pkgs.vulnix pkgs.qt6.qtwebengine pkgs.qt6.full pkgs.qt6.qtbase pkgs.qt6.qtwayland pkgs.mesa pkgs.mesa-demos pkgs.nano pkgs.gst_all_1.gst-vaapi pkgs.git pkgs.tlp pkgs.neofetch pkgs.cbonsai pkgs.asciiquarium pkgs.cowsay pkgs.nmap pkgs.noto-fonts pkgs.noto-fonts-cjk-sans pkgs.noto-fonts-emoji pkgs.cmatrix pkgs.oneko pkgs.fortune pkgs.figlet pkgs.pfetch pkgs.zstd pkgs.zlib pkgs.sl pkgs.ffmpeg_5-full pkgs.mixxx pkgs.vlc pkgs.mpv pkgs.youtube-dl pkgs.cpupower-gui pkgs.vaapiIntel pkgs.vaapiVdpau pkgs.microcodeIntel pkgs.x265 pkgs.wget2 pkgs.tldr pkgs.exa pkgs.duf pkgs.qbittorrent pkgs.avahi pkgs.glib pkgs.glibc pkgs.libde265 pkgs.metadata-cleaner pkgs.python3Full pkgs.pipenv pkgs.pip-audit pkgs.python310Packages.pip pkgs.vscodium pkgs.python310Packages.ipykernel pkgs.python310Packages.jupyter pkgs.jupyter pkgs.e2fsprogs pkgs.gparted pkgs.f2fs-tools pkgs.docker pkgs.easyeffects pkgs.adguardhome pkgs.certbot pkgs.radare2 ];
      programs.bash.enable = true;
      home.stateVersion = "21.11";

  };

}

 
