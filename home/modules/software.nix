{ pkgs, ... }: {
  # TODO: add other packages also
  home.packages = with pkgs; [
    mpv # video player
    ranger # file manager with image preview
    libreoffice # office
    obsidian # cool note taking app, closed source...
    # logseq # obsidian alternative, also open source but bullet point notes :(. they are good but i take paragraph notes more
    suwayomi-server # tachiyomi server for manga on pc...
    stremio
    vesktop # discord
    floorp # browser (firefox fork)
    firefox # firefox browser, better keep more browser, useful maybe(i know about:profiles, but different browser as whole)
    librewolf
    brave # chromium based browser, sometimes chromium based task needed
    chromium # vanilla chromium browser if ever needed
    gimp # image editor
    zoom-us # zoom client
    telegram-desktop
    qbittorrent # torrent client, best one for me. good for having ios file downloaded with resume
    motrix # download manager(aria2c) and torrent client, best at download. good torrent client but more like downloader only
    aria2 # downloader,
    tor # tor ... for educational purpose and onion technique experiments
    tor-browser # tor... for educational purpose and onion technique experiments
    mullvad-vpn # vpn
  ];
}
