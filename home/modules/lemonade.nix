
{ config, pkgs, ... }:

{
  # Enable lemonade as a systemd service
  systemd.user.services.lemonade = {
    Unit.Description = "Lemonade Clipboard Server";
    Install.WantedBy = [ "default.target" ];
    Service = {
      ExecStart = "${pkgs.lemonade}/bin/lemonade server -allow 127.0.0.1";
      Restart = "always";
      RestartSec = 5;
    };
  };

  # Ensure lemonade is installed
  home.packages = [
    pkgs.lemonade
  ];
}
