# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
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
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = false;

  boot.loader.systemd-boot.configurationLimit = 16;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.auto-optimise-store = true;
  services.fstrim.enable = true;

  # Setup keyfile
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };

  # Enable grub cryptodisk
  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices."luks-929d78f2-1fe8-4aa5-9bc6-5044eb3dde93".keyFile =
    "/crypto_keyfile.bin";
  # Enable swap on luks
  boot.initrd.luks.devices."luks-d4d09cdf-4894-44e8-b0d5-7187d8ee51cd".device =
    "/dev/disk/by-uuid/d4d09cdf-4894-44e8-b0d5-7187d8ee51cd";
  boot.initrd.luks.devices."luks-d4d09cdf-4894-44e8-b0d5-7187d8ee51cd".keyFile =
    "/crypto_keyfile.bin";

  networking.hostName = "nixos"; # Define your hostname.
  #
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  time.hardwareClockInLocalTime = true;

  powerManagement.powertop.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

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

  # Enable Wayland Session 
  xdg.portal.wlr.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = false;

  environment.gnome.excludePackages = with pkgs.gnome; [
    totem # video player
    epiphany # web browser
    geary # email application
    gnome-contacts # agenda application
  ];

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
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = false;
    alsa.support32Bit = false;
    pulse.enable = false;

    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  # use the example session manager (no others are packaged yet so this is enabled by default,
  # no need to redefine it in your config for now)
  #media-session.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tr3nts = {
    isNormalUser = true;
    description = "tr3nts";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs;
      [
        # firefox
        # thunderbird
      ];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { nixosConfig = config; };

    users.tr3nts = { pkgs, nixosConfig, ... }: {
      home.packages = with pkgs; [
        nixfmt
	nixpkgs-review
        firefox-wayland
        librewolf-wayland
        chromium
        thunderbird-wayland
        deltachat-desktop
        tdesktop
        onlyoffice-bin
        deluge
        vlc
	obs-studio
        chrome-gnome-shell
        gnomeExtensions.vitals
        tracker-miners
        gnome.gnome-tweaks
        wireshark
        ffmpeg_5-full
        vaapiVdpau
        vaapi-intel-hybrid
        gst_all_1.gst-vaapi
        libva-utils
        avahi
        busybox
        microcodeIntel
        x265
        libde265
        wget
        curl
        lm_sensors
        nmap
        btop
        dbus
        gnupg
        git
        cmake
        mesa
        mesa-demos
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        mixxx
        lm_sensors
        cmatrix
        neofetch
        asciiquarium
        cowsay
        oneko
        ponysay
        fortune
        figlet
        sl
        lolcat
        nyancat
        cbonsai
        distrobox
        zlib
        pfetch
        sublime4
	vscodium
        radicale
        valgrind
        postgresql
        jellyfin-web
        sftpman
        scrcpy
        adb-sync
        android-tools
        ventoy-bin
        libzdb
        #pdfarranger
        zstd
      ];
      home.stateVersion = "22.11";
      programs.bash.enable = true;
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      programs.neovim = {
        enable = true;
        viAlias = true;
        plugins = with pkgs.vimPlugins; [ editorconfig-vim vim-nix ];
        extraPackages = [ ];
        #withPython3 = false;
        extraConfig = "";
      };
    };
  };

  programs.dconf.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nixfmt
    git
    neovim
    emacs
    nethogs
    tlp
    gparted
  ];

  services.radicale = {
    enable = true;
    settings.server.hosts = [ "0.0.0.0:5232" ];
  };

  services.postgresql.enable = false;

  programs.gnupg.agent.enable = true;

  services.jellyfin.enable = true;

  nixpkgs.config.allowUnfree = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  # enable = true;
  # enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
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
  system.stateVersion = "22.05"; # Did you read the comment?

}

