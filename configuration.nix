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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxKernel.kernels.linux_hardened;
  #boot.kernelPackages = linuxKernel.packages.linux_hardened.opensnitch-ebpf
  #boot.kernelPackages = linuxKernel.packages.linux_zen.opensnitch-ebpf
  boot.kernel.sysctl."net.ipv4.conf.all.send_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.send_redirects" = false;
  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = true;
  boot.kernel.sysctl."net.core.bpf_jit_enable" = true;
  boot.kernel.sysctl."kernel.ftrace_enabled" = false;
  boot.kernel.sysctl."net.ipv4.conf.all.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.all.secure_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.secure_redirects" = false;
  boot.kernel.sysctl."net.ipv6.conf.all.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv6.conf.default.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.all.log_martians" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = true;
  

  # Optimising the store 
  nix.optimise.automatic = true;

  boot.initrd.luks.devices."luks-eff486b2-0601-47eb-b490-49940c0ac1a4".device =
    "/dev/disk/by-uuid/eff486b2-0601-47eb-b490-49940c0ac1a4";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.hostName = "killallbankers"; # Define your hostname.

  services.resolved = {
    enable = true;
    dnssec = "true";
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable GNOME Desktop Env. 
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # Enable the KDE Plasma Env.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  #services.xserver.displayManager.defaultSession = "plasma";

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
    alsa.support32Bit = false;
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
      # firefox
      opensnitch
      opensnitch-ui
      emacs
      # thunderbird
    ];
  };

 # environment.systemPackages = with pkgs; [
 # kdePackages.kdeconnect-kde
 # ];

# environment.gnome.excludePackages = (with pkgs; [
 # gnome-photos
 # gnome-tour
#]) ++ (with pkgs.gnome; [
#  cheese # webcam tool
#  epiphany # web browser
#  geary # email reader
#  evince # document viewer
#  gnome-characters
#  totem # video player
#  tali # poker game
#  iagno # go game
#  hitori # sudoku game
#  atomix # puzzle game
#]);

#  environment.plasma6.excludePackages  [
#    elisa
 #   plasma-browser-integration
 # ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home-manager.useGlobalPkgs = true;

  # Enable Docker Virtualization 
  virtualisation.docker.enable = true;

  services.cron = {
    enable = true;
    systemCronJobs =
      [ "     0  11  17  23  /etc/opensnitch/update_adlists.sh " ];
  };

  # Enable Virt-Manager/QEMU 

  #virtualisation.libvirtd.enable = true;
  #programs.virt-manager.enable = true;
  #services.qemuGuest.enable = true;

  # Enable KDEConnect 
 # programs.kdeconnect.enable = true;

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

  # nix.settings.experimental-features = [ "nix-command" "flakes" ];
  #  nix.package = pkgs.nixUnstable;
  #  nix.extraOptions = ''
  # experimental-features = nix-command flakes
  # '';

  # Enable Taiscale Recorded Future 
  services.tailscale.enable = true;

  # Enable Mullvad VPN 
  services.mullvad-vpn.enable = true;

  # Enable the OpenSSH daemon.
  #services.openssh.enable = false;  

  # Enable firejail
  #programs.firejail.enable = true;

  # Enable Privoxy Junkware 
  services.privoxy.enable = true;

  # Enable antivirus clamav and  keep the signatures' database updated
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ 1714  1764 ];
  #networking.firewall.allowedUDPPorts = [ 1714  1764 ];
  # Or disable the firewall altogether.
  #networking.firewall.enable = true;
  #networking.firewall.allowPing = false;
  #networking.nftables.enable = true;

  services.opensnitch = { enable = true; };

  environment.etc."/opensnitchd/system-fw.json" = {
    enable = true;
    source = "/etc/nixos/.nixos/.files/asuspc/system-fw.json";
    target = "opensnitchd/system-fw.json";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  home-manager.users.tr3nts = { pkgs, ... }: {
    home.packages = with pkgs; [
      keepassxc
      nextcloud-client
      mullvad-vpn
      tailscale
      nmap
      lanzaboote-tool
      sbctl
      naabu
      flameshot
      nixpkgs-review
      nixfmt-classic
      clamav
      redshift
      okular
      wireshark
      tor-browser
      mullvad-browser
      firefox
      chromium
      opensnitch
      opensnitch-ui
      ntpd-rs
      zap
      freetube
      mixxx
      cron
      libreddit
      socialscan
      niv
      tlp
      wayland
      metadata-cleaner
      privoxy
      pdns
      easyeffects
      ventoy-full
      lsp-plugins
      jami
      signal-desktop
      element-desktop
      thelounge
      hash-identifier
      qbittorrent
      sabnzbd
      radarr
      bcache-tools
      toybox
      auto-cpufreq
      tdesktop
      thunderbird
      onlyoffice-bin
      gnumake
      helix
      htop
      btop
    #  vulnix   // Deprecated since July 2021, check again in July 2024 if project works...
      mesa
      libvdpau-va-gl
      nano
      git
      python312
      python311Packages.pip
      go
      neofetch
      cbonsai
      asciiquarium
      cowsay
      nmap
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      cmatrix
      curl
      oneko
      fortune
      figlet
      pfetch
      sl
      smplayer
      mpv
      yt-dlp
      microcodeIntel
      gst_all_1.gst-libav
      gst_all_1.gst-vaapi
      opencl-headers
      python312
      wget2
      tldr
      glibc
      gparted
      lm_sensors
      fwupd
      fwupd-efi
      qemu_kvm
      valgrind
      nodejs_21
      czkawka
      intel-ocl
      intel-graphics-compiler
      vaapi-intel-hybrid
      unbound
      dnscrypt-proxy
    ];
    programs.bash.enable = true;
    services.opensnitch-ui.enable = true;
    home.enableNixpkgsReleaseCheck = false;
    home.stateVersion = "23.05";

  };

}

