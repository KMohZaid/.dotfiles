{ pkgs, lib, ... }:

let
in
{
  services.dunst = {
    enable = true;
    settings = {
      #### Dracula Theme - Converted to nix #### 

      # See dunst(5) for all configuration options

      global = {
        ### Display ###

        # Which monitor should the notifications be displayed on.
        monitor = 0;

        # Display notification on focused monitor. Possible modes are:
        # mouse: follow mouse pointer
        # keyboard: follow window with keyboard focus
        # none: don't follow anything
        follow = "mouse";

        ### Geometry ###

        # constant width of 300
        width = 300;

        # The maximum height of a single notification, excluding the frame.
        height = 300;

        # Position the notification in the top right corner
        origin = "top-right";

        # Offset from the origin
        offset = "10x50";

        # Scale factor. It is auto-detected if value is 0.
        scale = 0;

        # Maximum number of notification (0 means no limit)
        notification_limit = 0;

        ### Progress bar ###
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;

        # Show how many messages are currently hidden (because of notification_limit).
        indicate_hidden = true;

        # Transparency of the window. Range: [0; 100].
        transparency = 15;

        # Draw a line of "separator_height" pixel height between two notifications.
        separator_height = 1;

        # Padding between text and separator.
        padding = 8;

        # Horizontal padding.
        horizontal_padding = 10;

        # Padding between text and icon.
        text_icon_padding = 0;

        # Defines width in pixels of frame around the notification window.
        frame_width = 0;
        frame_color = "#282a36";

        # Define a color for the separator.
        separator_color = "frame";

        # Sort messages by urgency.
        sort = true;

        # Don't remove messages if the user is idle for longer than idle_threshold seconds.
        idle_threshold = 120;

        ### Text ###
        font = "Monospace 10";
        line_height = 0;

        markup = "full";

        format = "%s %p\n%b";

        alignment = "left";
        vertical_alignment = "center";

        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        ### Icons ###
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 64;
        icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";

        ### History ###
        sticky_history = true;
        history_length = 20;

        ### Misc/Advanced ###
        dmenu = "/usr/bin/dmenu -p dunst:";
        browser = "/usr/bin/firefox -new-tab";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 0;
        ignore_dbusclose = false;

        ### Wayland ###
        force_xwayland = false;

        ### Legacy ###
        force_xinerama = false;

        ### mouse ###
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      experimental = {
        per_monitor_dpi = false;
      };

      urgency_low = {
        background = "#282a36";
        foreground = "#6272a4";
        timeout = 10;
      };

      urgency_normal = {
        background = "#282a36";
        foreground = "#bd93f9";
        timeout = 10;
      };

      urgency_critical = {
        background = "#ff5555";
        foreground = "#f8f8f2";
        frame_color = "#ff5555";
        timeout = 0;
      };
    };
  };
}

