#  _   ___  __
# | |_| \ \/ / starnix -- (c) Hayden Young 2020
# |  _  |\  /  https://github.com/itshaydendev/starnix
# |_| |_|/_/   https://itshayden.dev
# 
{
  nixpkgs.config.allowUnfree = true;
  hardware = {
    enableAllFirmware = true;
  };
}
