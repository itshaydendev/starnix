{ config, pkgs, ... }:
{
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs;
    [
      # office
      libreoffice-fresh
      thunderbird-bin
      qalculate-gtk

      # media
      ffmpeg
      flameshot

      # dev
      asciinema

      # irc
      weechat

      # util
      qt4
      kdeconnect
    ];
}
