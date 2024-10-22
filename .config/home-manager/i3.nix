{ pkgs, lib, ... }:

let
  modifier = "Mod4";
  ws_names = {
    ws_1 = "1";
    ws_2 = "2";
    ws_3 = "3";
    ws_4 = "4";
    ws_5 = "5";
    ws_6 = "6";
    ws_7 = "7";
    ws_8 = "8";
    ws_9 = "9";
    ws_10 = "10";
  };
in
{
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
      config = {
        inherit modifier;

        bars = [ ];

        window = {
          border = 0;
          hideEdgeBorders = "both";
        };

        gaps = {
          inner = 10;
          outer = 1;
        };

        keybindings = {
          "${modifier}+e" = "exec ${pkgs.dolphin}/bin/dolphin";
          "${modifier}+shift+f" = "exec flatpak run io.github.zen_browser.zen";

          # Kitty terminal
          "${modifier}+Return" = "exec kitty || i3-sensible-terminal";

          # Rofi
          "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";

          # Screenshot
          "Print" = "exec \"pkill flameshot ; ${pkgs.flameshot}/bin/flameshot gui\"";

          # Audio Controller : Use pactl to adjust volume in PulseAudio.
          "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5% && killall -SIGUSR1 i3status";
          "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5% && killall -SIGUSR1 i3status";
          "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle && killall -SIGUSR1 i3status";
          "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle && killall -SIGUSR1 i3status";

          # Media Player Controller
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play";
          "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          "XF86AudioStop" = "exec ${pkgs.playerctl}/bin/playerctl stop";

          # Movement
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+h" = "focus left";
          "${modifier}+l" = "focus right";
          "${modifier}+Left" = "focus left";
          "${modifier}+Right" = "focus right";
          "${modifier}+Up" = "focus up";
          "${modifier}+Down" = "focus down";

          # Workspaces
          "${modifier}+1" = "workspace ${ws_names.ws_1}";
          "${modifier}+2" = "workspace ${ws_names.ws_2}";
          "${modifier}+3" = "workspace ${ws_names.ws_3}";
          "${modifier}+4" = "workspace ${ws_names.ws_4}";
          "${modifier}+5" = "workspace ${ws_names.ws_5}";
          "${modifier}+6" = "workspace ${ws_names.ws_6}";
          "${modifier}+7" = "workspace ${ws_names.ws_7}";
          "${modifier}+8" = "workspace ${ws_names.ws_8}";
          "${modifier}+9" = "workspace ${ws_names.ws_9}";
          "${modifier}+0" = "workspace ${ws_names.ws_10}";

          # Move container to workspace
          "${modifier}+Shift+1" = "move container to workspace ${ws_names.ws_1}; workspace ${ws_names.ws_1}";
          "${modifier}+Shift+2" = "move container to workspace ${ws_names.ws_2}; workspace ${ws_names.ws_2}";
          "${modifier}+Shift+3" = "move container to workspace ${ws_names.ws_3}; workspace ${ws_names.ws_3}";
          "${modifier}+Shift+4" = "move container to workspace ${ws_names.ws_4}; workspace ${ws_names.ws_4}";
          "${modifier}+Shift+5" = "move container to workspace ${ws_names.ws_5}; workspace ${ws_names.ws_5}";
          "${modifier}+Shift+6" = "move container to workspace ${ws_names.ws_6}; workspace ${ws_names.ws_6}";
          "${modifier}+Shift+7" = "move container to workspace ${ws_names.ws_7}; workspace ${ws_names.ws_7}";
          "${modifier}+Shift+8" = "move container to workspace ${ws_names.ws_8}; workspace ${ws_names.ws_8}";
          "${modifier}+Shift+9" = "move container to workspace ${ws_names.ws_9}; workspace ${ws_names.ws_9}";
          "${modifier}+Shift+0" = "move container to workspace ${ws_names.ws_10}; workspace ${ws_names.ws_10}";

          # Misc
          "${modifier}+shift+q" = "kill";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+z" = "split h";
          "${modifier}+x" = "split v";
          "${modifier}+r" = "mode resize";

          "${modifier}+Shift+e" =  "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'\"";
          "${modifier}+Shift+r" = "reload";
          "${modifier}+Shift+c" = "restart";
        };

        modes.resize = {
          "h" = "resize grow width 10 px or 10 ppt";
          "j" = "resize shrink height 10 px or 10 ppt";
          "k" = "resize grow height 10 px or 10 ppt";
          "l" = "resize shrink width 10 px or 10 ppt";
          "Escape" = "mode default";
        };

        startup = [
          {
            command = "${pkgs.feh}/bin/feh --bg-fill ~/.background.png";
            always = true;
            notification = false;
          }
          {
            command = "~/.config/polybar/launch.sh";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.xbanish}/bin/xbanish";
            always = true;
            notification = false;
          }
        ];
      };
    };
  };
  home.file.".background.png".source = ./background.png;
}
