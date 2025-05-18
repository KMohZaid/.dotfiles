{ plasma-manager, pkgs, ... }:
{
  # TODO: clean this up
  # TODO: maybe move to folder called plasma with rc2nix.nix file
  # TODO: in future, get rid of rc2nix.nix file

  # kde stuff needed for kde setting app and some utility, qml modules...
  home.packages = with pkgs; [
    kdePackages.systemsettings
    kdePackages.kirigami
    kdePackages.knewstuff
    qt6.qtpositioning
    qt6.qtdeclarative

    # other plasma stuff
    sweet-nova
    sweet-folders
  ];

  # ENV : Trick KDE apps into thinking you're in KDE
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "kde";
    QT_PLUGIN_PATH = "${pkgs.kdePackages.plasma-workspace}/lib/qt-6/plugins:${pkgs.qt6.qtbase}/lib/qt-6/plugins";
    QML_IMPORT_PATH = "${pkgs.kdePackages.plasma-workspace}/lib/qt-6/qml:${pkgs.qt6.qtdeclarative}/lib/qt-6/qml";
    XDG_DATA_DIRS = "${pkgs.kdePackages.plasma-workspace}/share:${pkgs.qt6.qtbase}/share:$XDG_DATA_DIRS";
  };

  imports = [
    plasma-manager.homeManagerModules.plasma-manager
    ./plasma.rc2nix.nix
  ];

  # Stuff rc2nix ignores
  # 1. ~/.config/kdedefaults/ -> kde set theme here when changed from settings
  programs.plasma = {
    enable = true;

    shortcuts = {
      "services/org.kde.spectacle.desktop"."RectangularRegionScreenShot" = [
        "Meta+Shift+Print"
        "Print"
      ];
    };

    workspace = {
      theme = "Sweet";
      lookAndFeel = "Sweet";
      cursor = {
        size = 48;
        theme = "macOS";
      };
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/ScarletTree/";
    };

    # INFO: for panel logic, thanks to https://github.com/nix-community/plasma-manager/blob/d16bbded0ae452bc088489e7dca3ef58d8d1830b/examples/home.nix#L50

    # XXX: checkout
    #       1. https://github.com/nix-community/plasma-manager/blob/trunk/modules/ - read plasma-manager widget module nix file to figer out of configure them
    #       2. https://develop.kde.org/docs/plasma/scripting/keys/ - to configure directly via kde api

    panels = [
      # Windows-like panel at the bottom
      {
        location = "bottom";
        widgets = [
          # Kickoff widget ::: App menu like window Start menu
          # XXX: directly using  kde api because favorites is not a option in plasma-manager yet
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "nix-snowflake-white";
                alphaSort = true;
                favorites = [
                  "preferred://browser"
                  "preferred://terminal"
                  "vesktop.desktop"
                  "org.telegram.desktop"
                  "org.kde.kontact.desktop"
                  "systemsettings.desktop"
                  "org.kde.dolphin.desktop"
                  "org.kde.discover.desktop"
                ];
              };
            };
          }

          # Pager ::: Workspaces View
          "org.kde.plasma.pager" # TODO: configure it?

          # Task Manager ::: Task bar
          {
            iconTasks = {
              launchers = [
                "applications:systemsettings.desktop"
                #  "preferred://filemanager" # XXX: long live "Meta+E"
                "preferred://browser"
                "preferred://terminal"
              ];
            };
          }

          # Margins Separator ::: Spacer
          "org.kde.plasma.marginsseparator"

          # Dex ::: Systray
          {
            systemTray.items = {
              # We explicitly show bluetooth and battery
              shown = [
                "org.kde.plasma.battery"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.networkmanagement"
              ];
            };
          }

          # Digital Clock
          {
            digitalClock = {
              calendar.firstDayOfWeek = "sunday";
              time.format = "12h";
            };
          }

          # Show Desktop ::: Peek at desktop
          "org.kde.plasma.showdesktop"

        ];
        # hiding = "autohide"; # hide when not hovering
      }
      # TODO: Configure Top Panel

      # Application name, Global menu and Song information and playback controls at the top
      {
        location = "top";
        height = 26;
        widgets = [
          {
            applicationTitleBar = {
              behavior = {
                activeTaskSource = "activeTask";
              };
              layout = {
                elements = [ "windowTitle" ];
                horizontalAlignment = "left";
                showDisabledElements = "deactivated";
                verticalAlignment = "center";
              };
              overrideForMaximized.enable = false;
              # XXX: below is regex example for title replacement
              titleReplacements = [
                {
                  type = "regexp";
                  originalTitle = "^Brave Web Browser$";
                  newTitle = "Brave";
                }
                {
                  type = "regexp";
                  originalTitle = "\\\\bDolphin\\\\b";
                  newTitle = "File manager";
                }
              ];
              windowTitle = {
                font = {
                  bold = false;
                  fit = "fixedSize";
                  size = 12;
                };
                hideEmptyTitle = true;
                margins = {
                  bottom = 0;
                  left = 10;
                  right = 5;
                  top = 0;
                };
                source = "appName";
              };
            };
          }
          # Application Menu ::: Menu provided by app to kde api
          "org.kde.plasma.appmenu"
          # Spacer
          "org.kde.plasma.panelspacer"
          # Player indicatior ::: Song/Video information and playback controls
          {
            plasmusicToolbar = {
              panelIcon = {
                albumCover = {
                  useAsIcon = true; # instead of music icon, display album cover as icon
                  radius = 8;
                };
                # icon = "view-media-track"; # icon to display when no album cover is available or not in use?
              };
              playbackSource = "auto";
              songText = {
                displayInSeparateLines = false; # if true, display artist/author/youtuber/etc. in separate lines
                maximumWidth = 500;
              };
            };
          }
        ];
      }
    ];

  };

}
