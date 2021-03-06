#  _   ___  __
# | |_| \ \/ / starnix -- (c) Hayden Young 2020
# |  _  |\  /  https://github.com/itshaydendev/starnix
# |_| |_|/_/   https://itshayden.dev
# 
{ config, pkgs, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/master)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
  environment.systemPackages = with pkgs;
    [
      # NodeJS
      nodejs-12_x
      
      # PHP
      php73
      php73Packages.composer

      # Golang
      go
      gcc

      # Misc.
      insomnia # api testing
      mkcert # SSL cert generation
      jetbrains.datagrip
      mariadb-client
      unstable.azuredatastudio
      github-cli
    ];
}
