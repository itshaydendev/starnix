#  _   ___  __
# | |_| \ \/ / starnix -- (c) Hayden Young 2020
# |  _  |\  /  https://github.com/itshaydendev/starnix
# |_| |_|/_/   https://itshayden.dev
# 
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs;
    [
      # system tools
      fzf
      ripgrep
      sd
      gitAndTools.delta
      home-manager
      git
      file
      jq
      nmap
      wget
      curl
      aria2
      imagemagick
      bat
      tmux

      # tools
      taskwarrior
      python37Packages.bugwarrior

      # monitoring
      bandwhich
      iperf3
      lm_sensors
      lsof
      hwinfo
      smartmontools
      gotop
      htop
      iotop
      neofetch
      lshw
      pciutils
      usbutils
      inetutils

      # sec
      cryptsetup
      tomb
      pwgen

      # fs
      fd
      exa
      unzip
      unrar
      atool
      bind
      dosfstools
      mtools
      sshfs
      ntfs3g
      exfat
      sshfsFuse
      rsync
    ];

    services.udev.packages = [ pkgs.libu2f-host ];
}
