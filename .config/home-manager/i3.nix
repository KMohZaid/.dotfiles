{ pkgs, lib, ... }:

let
  modifier = "Mod4";
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

        keybindings = {
          "${modifier}+e" = "exec ${pkgs.dolphin}/bin/dolphin";
          "${modifier}+shift+f" = "exec flatpak run io.github.zen_browser.zen";

          # Kitty terminal
          "${modifier}+Return" = "exec kitty || i3-sensible-terminal";

          # Rofi
          "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";

          # Screenshot
          "${modifier}+Print" = "exec ${pkgs.flameshot}/bin/flameshot gui -c";
          "Print" = "exec ${pkgs.flameshot}/bin/flameshot gui";

          # Use pactl to adjust volume in PulseAudio.
          "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5% && killall -SIGUSR1 i3status";
          "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5% && killall -SIGUSR1 i3status";
          "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle && killall -SIGUSR1 i3status";
          "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle && killall -SIGUSR1 i3status";

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
          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";

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
          {
            command = "${pkgs.kitty}/bin/kitty";
            always = false;
            notification = false;
          }
        ];
      };
    };
  };
  home.file.".background.png".source = ./background.png;
}
