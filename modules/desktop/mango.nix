{inputs, ...}: {
  flake.modules.nixos."mango" = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      inputs.mangowc.nixosModules.mango
    ];

    # NixOS
    programs.mangowc.enable = true;
    environment.systemPackages = with pkgs; [
      yazi
      grim
      slurp
      satty
      wayfreeze
    ];

    # Home Manager
    home-manager.users.${config.user.name} = {...}: {
      imports = [
        inputs.mangowc.hmModules.mango
      ];

      home.file.".config/mango/scripts".source = ../../resources/mango/scripts;

      wayland.windowManager.mango = {
        enable = true;
        systemd.enable = true;
        settings = {
          # Startup
          exec-once = [
            "dms run"
          ];
          # Window effect
          blur = 1;
          blur_layer = 0;
          blur_optimized = 1;
          blur_params_num_passes = 2;
          blur_params_radius = 5;
          blur_params_noise = 0.02;
          blur_params_brightness = 0.9;
          blur_params_contrast = 0.9;
          blur_params_saturation = 1.2;

          shadows = 0;

          border_radius = 0;
          focused_opacity = 1.0;
          unfocused_opacity = 0.7;

          # Monitor rules
          monitorrule = [
            "model:M34WQ,width:3440,height:1440,refresh:144.001007,x:0,y:0"
            "model:0x0BC9,width:2560,height:1600,refresh:165,x:3440,y:800"
          ];

          # Tag rules
          tagrule = [
            "id:1,monitor_model:M34WQ,layout_name:dwindle"
            "id:2,monitor_model:M34WQ,layout_name:dwindle"
            "id:3,monitor_model:M34WQ,layout_name:dwindle"
            "id:4,monitor_model:M34WQ,layout_name:dwindle"
            "id:5,monitor_model:M34WQ,layout_name:dwindle"
            "id:6,monitor_model:M34WQ,layout_name:dwindle"
            "id:7,monitor_model:M34WQ,layout_name:dwindle"
            "id:8,monitor_model:M34WQ,layout_name:dwindle"
            "id:9,monitor_model:M34WQ,layout_name:dwindle"
            "id:1,monitor_model:0x0BC9,layout_name:scroller"
            "id:2,monitor_model:0x0BC9,layout_name:scroller"
            "id:3,monitor_model:0x0BC9,layout_name:scroller"
            "id:4,monitor_model:0x0BC9,layout_name:scroller"
            "id:5,monitor_model:0x0BC9,layout_name:scroller"
            "id:6,monitor_model:0x0BC9,layout_name:scroller"
            "id:7,monitor_model:0x0BC9,layout_name:scroller"
            "id:8,monitor_model:0x0BC9,layout_name:scroller"
            "id:9,monitor_model:0x0BC9,layout_name:scroller"
          ];
          windowrule = [
            "isfullscreen:1,title:Steam Big Picture Mode"
          ];
          # Binds
          bind = [
            # Reload config
            "SUPER+ALT,r,reload_config"

            # Close window
            "SUPER,q,killclient,"

            # Apps
            "SUPER,a,setkeymode,quicklaunch"
            "SUPER,return,spawn,ghostty"

            # Shell
            "SUPER,space,spawn,dms ipc launcher toggle"
            "SUPER,w,spawn,dms ipc powermenu toggle"
            "SUPER,c,spawn,dms ipc clipboard toggle"
            "NONE,XF86AudioLowerVolume,spawn,dms ipc audio decrement 5"
            "NONE,XF86AudioRaiseVolume,spawn,dms ipc audio increment 5"
            "NONE,XF86MonBrightnessDown,spawn_shell,dms ipc brightness decrement 5 backlight:amdgpu_bl2 & $HOME/.config/mango/scripts/external-mon-brightness.sh down"
            "NONE,XF86MonBrightnessUp,spawn_shell,dms ipc brightness increment 5 backlight:amdgpu_bl2 & $HOME/.config/mango/scripts/external-mon-brightness.sh up"
            "NONE,XF86AudioPlay,spawn,dms ipc mpris playPause"
            "NONE,XF86AudioPrev,spawn,dms ipc mpris previous"
            "NONE,XF86AudioNext,spawn,dms ipc mpris next"

            # Screenshot
            "NONE,Print,spawn,$HOME/.config/mango/scripts/screenshot.sh fullscreen"
            "SUPER,Print,spawn,$HOME/.config/mango/scripts/screenshot.sh window"
            "SHIFT,Print,spawn,$HOME/.config/mango/scripts/screenshot.sh freeze-region"
            "SHIFT+ALT,Print,spawn,$HOME/.config/mango/scripts/screenshot.sh region"

            # Focus & Movement
            "SUPER,h,focusdir,left"
            "SUPER,j,focusdir,down"
            "SUPER,k,focusdir,up"
            "SUPER,l,focusdir,right"

            "SUPER+SHIFT,h,exchange_client,left"
            "SUPER+SHIFT,j,exchange_client,down"
            "SUPER+SHIFT,k,exchange_client,up"
            "SUPER+SHIFT,l,exchange_client,right"
            "SUPER,Left,focusmon,left"
            "SUPER,Right,focusmon,right"
            "SUPER+SHIFT,Left,tagmon,left"
            "SUPER+SHIFT,Right,tagmon,right"
            "SUPER,x,minimized," # To scratchpad
            # Pop scratchpad back to tiled
            "SUPER+SHIFT,x,spawn_shell,mmsg dispatch restore_minimized && mmsg dispatch togglefloating"
            "SUPER,1,view,1,0"
            "SUPER,2,view,2,0"
            "SUPER,3,view,3,0"
            "SUPER,4,view,4,0"
            "SUPER,5,view,5,0"
            "SUPER,6,view,6,0"
            "SUPER,7,view,7,0"
            "SUPER,8,view,8,0"
            "SUPER,9,view,9,0"
            "SUPER,y,viewcrossmon,1,model:M34WQ"
            "SUPER,u,viewcrossmon,2,model:M34WQ"
            "SUPER,i,viewcrossmon,3,model:M34WQ"
            "SUPER,o,viewcrossmon,4,model:M34WQ"
            "SUPER,p,viewcrossmon,5,model:M34WQ"
            "SUPER,n,viewcrossmon,1,model:0x0BC9"
            "SUPER,m,viewcrossmon,2,model:0x0BC9"
            "SUPER,comma,viewcrossmon,3,model:0x0BC9"
            "SUPER,period,viewcrossmon,4,model:0x0BC9"

            "SUPER+SHIFT,y,tagcrossmon,1,model:M34WQ"
            "SUPER+SHIFT,u,tagcrossmon,2,model:M34WQ"
            "SUPER+SHIFT,i,tagcrossmon,3,model:M34WQ"
            "SUPER+SHIFT,o,tagcrossmon,4,model:M34WQ"
            "SUPER+SHIFT,p,tagcrossmon,5,model:M34WQ"
            "SUPER+SHIFT,n,tagcrossmon,1,model:0x0BC9"
            "SUPER+SHIFT,m,tagcrossmon,2,model:0x0BC9"
            "SUPER+SHIFT,comma,tagcrossmon,3,model:0x0BC9"
            "SUPER+SHIFT,period,tagcrossmon,4,model:0x0BC9"
            "SUPER+SHIFT,1,view,1,0"
            "SUPER+SHIFT,2,view,2,0"
            "SUPER+SHIFT,3,view,3,0"
            "SUPER+SHIFT,4,view,4,0"
            "SUPER+SHIFT,5,view,5,0"
            "SUPER+SHIFT,6,view,6,0"
            "SUPER+SHIFT,7,view,7,0"
            "SUPER+SHIFT,8,view,8,0"
            "SUPER+SHIFT,9,view,9,0"
            "SUPER+CTRL,h,resizewin,-25,+0"
            "SUPER+CTRL,j,resizewin,+0,+25"
            "SUPER+CTRL,k,resizewin,+0,-25"
            "SUPER+CTRL,l,resizewin,+25,+0"

            "SUPER,semicolon,switch_layout"

            # Window status
            "SUPER,f,togglefullscreen,"
            "SUPER+CTRL,f,togglemaximizescreen,"
            "SUPER+SHIFT,f,togglefloating,"
            "SUPER,Tab,toggleoverview,"
            "SUPER,s,toggle_scratchpad"

            # Dwindle
            "SUPER+ALT,h,dwindle_split_horizontal"
            "SUPER+ALT,j,dwindle_split_vertical"
            "SUPER+ALT,k,dwindle_split_vertical"
            "SUPER+ALT,l,dwindle_split_horizontal"

            # Scroller
            "SUPER+ALT,e,switch_proportion_preset,"
            "SUPER+ALT,h,scroller_stack,left"
            "SUPER+ALT,j,scroller_stack,down"
            "SUPER+ALT,k,scroller_stack,u"
            "SUPER+ALT,l,scroller_stack,right"
          ];
          keymode = {
            quicklaunch = {
              bind = [
                "NONE,escape,setkeymode,default"
                "SUPER,a,setkeymode,default"
                "NONE,t,spawn_shell,mmsg dispatch setkeymode,default & ghostty"
                "NONE,f,spawn_shell,mmsg dispatch setkeymode,default & zen-beta"
                "NONE,s,spawn_shell,mmsg dispatch setkeymode,default & steam"
                "NONE,d,spawn_shell,mmsg dispatch setkeymode,default & ghostty -e yazi"
              ];
            };
          };
          mousebind = [
            "SUPER,btn_left,moveresize,curmove"
            "SUPER,btn_right,moveresize,curresize"
          ];
          axisbind = [
            "SUPER,UP,viewtoleft_have_client"
            "SUPER,DOWN,viewtoright_have_client"
          ];
          animations = 1;
          layer_animations = 1;
          animation_type_open = "zoom";
          animation_type_close = "zoom";
          animation_fade_in = 1;
          animation_fade_out = 1;
          tag_animation_direction = 1;
          zoom_initial_ratio = 0.4;
          zoom_end_ratio = 0.8;
          fadein_begin_opacity = 0.5;
          fadeout_begin_opacity = 0.8;
          animation_duration_move = 500;
          animation_duration_open = 400;
          animation_duration_tag = 350;
          animation_duration_close = 800;
          animation_duration_focus = 0;
          animation_curve_open = "0.46,1.0,0.29,1";
          animation_curve_move = "0.46,1.0,0.29,1";
          animation_curve_tag = "0.46,1.0,0.29,1";
          animation_curve_close = "0.08,0.92,0,1";
          animation_curve_focus = "0.46,1.0,0.29,1";
          animation_curve_opafadeout = "0.5,0.5,0.5,0.5";
          animation_curve_opafadein = "0.46,1.0,0.29,1";

          # Appearence
          gappih = 5;
          gappiv = 5;
          gappoh = 10;
          gappov = 10;
          scratchpad_width_ratio = 0.8;
          scratchpad_height_ratio = 0.9;
          borderpx = 4;
          source = [
            "./dms/colors.conf"
          ];
          rootcolor = "0x201b14ff";
          dropcolor = "0x8FBA7C55";
          splitcolor = "0xEB441EFF";
          maximizescreencolor = "0x89aa61ff";
          scratchpadcolor = "0x516c93ff";
          globalcolor = "0xb153a7ff";
          overlaycolor = "0x14a57cff";

          # Keyboard
          repeat_rate = 25;
          repeat_delay = 600;
          numlockon = 0;
          xkb_rules_layout = "hp";

          # Mouse & Trackpad
          mouse_natural_scrolling = 0;
          disable_trackpad = 0;
          tap_to_click = 1;
          tap_and_drag = 1;
          drag_lock = 1;
          trackpad_natural_scrolling = 1;
          disable_while_typing = 1;
          left_handed = 0;
          middle_button_emulation = 1;
          sloppyfocus = 0;

          enable_hotarea = 0;
          ov_tab_mode = 1;
          ov_no_resize = 1;
          overviewgappi = 5;
          overviewgappo = 15;

          # Dwindle
          dwindle_smart_split = 0;
          dwindle_hsplit = 0;
          dwindle_vsplit = 0;
          dwindle_preserve_split = 0;
          dwindle_smart_resize = 0;
          dwindle_drop_simple_split = 0;
          dwindle_manual_split = 1;

          # Scroller
          scroller_structs = 20;
          scroller_default_proportion = 0.8;
          scroller_focus_center = 0;
          scroller_prefer_center = 0;
          edge_scroller_pointer_focus = 1;
          edge_scroller_focus_allow_speed = 0.0;
          scroller_default_proportion_single = 1.0;
          scroller_proportion_preset = "0.25,0.5,0.8,1.0";

          # Master
          new_is_master = 1;
          default_mfact = 0.55;
          default_nmaster = 1;
          smartgaps = 0;

          # General
          circle_layout = "dwindle,scroller";
          scratchpad_cross_monitor = 1;
          no_border_when_single = 0;
          axis_bind_apply_timeout = 100;
          focus_on_activate = 1;
          idleinhibit_ignore_visible = 1;
          warpcursor = 0;
          focus_cross_monitor = 0;
          exchange_cross_monitor = 1;
          focus_cross_tag = 0;
          enable_floating_snap = 0;
          snap_distance = 30;
          cursor_size = 24;
          drag_tile_to_tile = 1;
          drag_tile_small = 1;
        };
      };
    };
  };
}
