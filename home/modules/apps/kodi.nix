{ pkgs, ... }: {
  programs.kodi = {
    enable = true;
    package = pkgs.kodi-wayland.passthru.withPackages
      (kodiPkgs: with kodiPkgs; [ netflix jellycon ]);
    # addonSettings = {};
    settings = {
      services = {
        devicename = "viewscreen";
        esallinterfaces = "true";
        webserver = "true";
        webserverport = "8080";
        webserverauthentication = "false";
        zeroconf = "true";
      };
    };
  };
}
