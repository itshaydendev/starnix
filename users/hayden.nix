{ config, pkgs, vars, ... }:
{
  vars.user = "hayden";
  users.users.${vars.user} = {
    description = "Hayden Young";
  };

  location.latitude = 53.32;
  location.longitude = -1.34;

  networking.extraHosts =
    ''
      127.0.0.1 dev.lcl
    '';

  systemd.tmpfiles.rules =
    [
      "d /vvv 0700 1000 wheel" # secrets
      "d /c 0744 1000 wheel" # code
    ];

  home-manager = {
    users.${vars.user} = {
      programs.git = {
        userName = "Hayden Young";
	userEmail = "hayden@itshayden.dev";
      };

      home.file.".wallpaper".source = ../assets/wallpapers/main.png;
    };
  };
}