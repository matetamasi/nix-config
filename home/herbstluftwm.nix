{ config, pkgs, nixvim, ... }:

{
  xsession.windowManager.herbstluftwm = {
    enable = true;
    
    settings = {
      default_frame_layout = 2;
      frame_gap = 10;
      window_border_width = 2;
      window_gap = -2; # Tiling window border overlap
      window_border_inner_width = 0; # Don't touch
      frame_padding = 0; # Don't touch
      frame_border_inner_width = 0; # Don't touch
      frame_border_width = 2; # Outside frame
      frame_transparent_width = 5; # If below is true how much frame is left
      frame_bg_transparent = true;
      always_show_frame = false; # Display all frames or only focused/used
      frame_active_opacity = 50;
      frame_normal_opacity = 50;
      smart_frame_surroundings = true; # Last frame that is left loses border
      smart_window_surroundings = true; # Last window that is left loses border
      snap_distance = 20;
      snap_gap = 0;
      raise_on_focus = true;
      raise_on_click = true;
      focus_follows_mouse = false;
      focus_stealing_prevention = false;
      update_dragged_clients = 1;

      frame_border_active_color = "#ebdbb2";
      frame_bg_active_color = "#ebdbb2";
      window_border_active_color ="#ebdbb2";
      window_border_urgent_color = "#b16286";
      frame_border_inner_color = "black";
      window_border_inner_color = "black";
      window_border_normal_color = "#0A0A0A";
      frame_border_normal_color = "#0F0F0F";
      frame_bg_normal_color = "#0F0F0F";

      tree_style = "'╾│ ├└╼─┐'";

      auto_detect_monitors = true;
    };

    keybinds = {
      # Herbstluftwm control
      Mod4-Control-q = "quit";
      Mod4-Control-r = "reload";
      Mod4-Control-x = "spawn systemctl suspend";
      
      # Window Focusing
      Mod4-Left = "focus left";
      Mod4-Down = "focus down";
      Mod4-Up = "focus up";
      Mod4-Right = "focus right";
      Mod4-h = "focus left";
      Mod4-j = "focus down";
      Mod4-k = "focus up";
      Mod4-l = "focus right";
      Mod4-u = "jumpto urgent";

      # Move between tags
      Mod4-1 = "use_index 0";
      Mod4-Shift-1 = "move_index 0";
      Mod4-2 = "use_index 1";
      Mod4-Shift-2 = "move_index 1";
      Mod4-3 = "use_index 2";
      Mod4-Shift-3 = "move_index 2";
      Mod4-4 = "use_index 3";
      Mod4-Shift-4 = "move_index 3";
      Mod4-5 = "use_index 4";
      Mod4-Shift-5 = "move_index 4";

      # switch between layered windows in the same frame
      Mod4-Tab = "cycle";
      
      # Window actions
      Mod4-q = "close";
      Mod4-Shift-Left = "shift left";
      Mod4-Shift-Down = "shift down";
      Mod4-Shift-Up = "shift up";
      Mod4-Shift-Right = "shift right";
      Mod4-Shift-h = "shift left";
      Mod4-Shift-j = "shift down";
      Mod4-Shift-k = "shift up";
      Mod4-Shift-l = "shift right";
      Mod4-f = "fullscreen toggle";
      Mod4-y = "set_attr clients.focus.floating toggle";
      Mod4-p = "pseudotile toggle";
      
      # Frame operations
      Mod4-s = "chain , split auto , cycle_frame 1";
      Mod4-c = "remove";
      Mod4-Alt-Left = "chain , split left 0.5 , focus -e left";
      Mod4-Alt-Down = "chain , split bottom 0.5 , focus -e down";
      Mod4-Alt-Up = "chain , split top 0.5 , focus -e up";
      Mod4-Alt-Right = "chain , split right 0.5 , focus -e right";
      Mod4-Alt-h = "chain , split left 0.5 , focus -e left";
      Mod4-Alt-j = "chain , split bottom 0.5 , focus -e down";
      Mod4-Alt-k = "chain , split top 0.5 , focus -e up";
      Mod4-Alt-l = "chain , split right 0.5 , focus -e right";
      Mod4-b = "chain , lock , rotate , unlock";
      Mod4-n = "chain , lock , rotate , rotate , rotate , unlock";
      
      # Resizing frames
      Mod4-Control-Left = "resize left +0.05";
      Mod4-Control-Down = "resize down +0.05";
      Mod4-Control-Up = "resize up +0.05";
      Mod4-Control-Right = "resize right +0.05";
      Mod4-Control-h = "resize left +0.05";
      Mod4-Control-j = "resize down +0.05";
      Mod4-Control-k = "resize up +0.05";
      Mod4-Control-l = "resize right +0.05";
      
      Mod4-period = "cycle_value frame_gap 0 5 10 15 20 25 30 35 40";
      Mod4-comma = "cycle_value frame_gap 40 35 30 25 20 15 10 5 0";
      
      Mod4-Control-f = "floating toggle";
      Mod4-Shift-f = "set_attr clients.focus.floating toggle";
      
      # Application launching
      Mod4-Return = "spawn wezterm"; #TODO: use $TERM instead
      Mod4-r = "spawn .config/polybar/scripts/launcher.sh";
      Mod4-Control-p = "spawn .config/polybar/scripts/powermenu.sh";
      

      #screenshot (using scrot)
      #mkdir -p $HOME/screenshots
      Print = "spawn scrot 'Pictures/Screenshots/%Y-%m-%d_%H-%M-%S_$wx$h.png'";
      Mod4-Print = "spawn scrot 'Pictures/Screenshots/%Y-%m-%d_%H-%M-%S_$wx$h.png' --focused";
      Ctrl-Print = "spawn scrot 'Pictures/Screenshots/%Y-%m-%d_%H-%M-%S_$wx$h.png' --select --freeze";
      Shift-Print = "spawn scrot -e 'xclip -selection clipboard -t image/png -i $f && rm $f'";
      Ctrl-Shift-Print = "spawn scrot --select --freeze -e 'xclip -selection clipboard -t image/png -i $f && rm $f'";
      
      # Media keys
      XF86AudioRaiseVolume = "spawn pamixer -i 5";
      XF86AudioLowerVolume = "spawn pamixer -d 5";
      XF86AudioMute = "spawn pamixer -t";
      XF86MonBrightnessUp = "spawn xbacklight -inc 5";
      XF86MonBrightnessDown = "spawn xbacklight -dec 5";
      
      XF86AudioPlay = "spawn playerctl play-pause";
      XF86AudioPrev = "spawn playerctl previous";
      XF86AudioNext = "spawn playerctl next";
    };

    mousebinds = {
      Mod4-Button1 = "move";
      Mod4-Button2 = "zoom";
      Mod4-Button3 = "resize";
    };

    tags = [
    "1"
    "2"
    "3"
    "4"
    "5"
    ];

    extraConfig = ''
      xsetroot -solid '#9900dd'
      set_layout max
      detect_monitors

      # Set key chord for launching apps
      # Create the array of keys
      app_keys=(f s)
      # Build the command to unbind the keys
      unbind=( )
      for k in "''${app_keys[@]}" Escape ; do
      	unbind+=( , keyunbind "$k" )
      done
      
      # Set apps to launch
      herbstclient keybind Mod4-a chain \
      	'->' keybind "''${app_keys[0]}" chain "''${unbind[@]}" , spawn firefox \
      	'->' keybind "''${app_keys[1]}" chain "''${unbind[@]}" , spawn steam \
      	'->' keybind Escape chain "''${unbind[@]}"
      
      #enable ibus to type unicode symbols
      ibus-daemon -rxRd
    '';
    
    rules = [
      "focus=on" # Normally focus new clients
      "windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' floating=on"
      "windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on"
      "windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off"
      "windowtype~'_NET_WM_WINDOW_TYPE_(FULLSCREEN|FS)' fullscreen=on"
      "instance='gcolor2' floating=on"
      "instance='feh' floating=on"
      "instance='nitrogen' floating=on"
      "class='Pidgin' floating=on"
      "class='Gbdfed' floating=on"
      "title='Loading Tixati...' manage=off"
    ];
  };
}
