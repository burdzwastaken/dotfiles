{ pkgs, ... }:

let
  ghostty-wrapper = pkgs.writeShellScriptBin "ghostty-wrapped" ''
    #!${pkgs.bash}/bin/bash

    # unset WAYLAND_DISPLAY to ensure GTK respects GDK_BACKEND=x11
    unset WAYLAND_DISPLAY

    # the following two lines to explicitly point to Nix's Mesa libraries/drivers.
    export LD_LIBRARY_PATH="${pkgs.mesa}/lib:$LD_LIBRARY_PATH"
    export LIBGL_DRIVERS_PATH="${pkgs.mesa}/lib/dri"
    # --------------------------------------------

    # execute the real Ghostty binary, passing all arguments
    exec ${pkgs.ghostty}/bin/ghostty "$@"
  '';
in
{
  xdg.configFile."sway/config".text = ''
    # Sway configuration for laptop

    set $modifier Mod1
    set $terminal ${ghostty-wrapper}/bin/ghostty-wrapped
    set $menu rofi -show drun

    font pango:FuraCode Nerd Font Mono 9

    # Dark Purple theme colors
    default_border pixel 3
    client.focused          #9a76b3 #121015 #d8d8de #ce4a4a   #9a76b3
    client.focused_inactive #3c3242 #121015 #d8d8de #3c3242   #3c3242
    client.unfocused        #1e1a22 #121015 #3c3242 #1e1a22   #1e1a22
    client.urgent           #ce4a4a #121015 #d8d8de #ce4a4a   #ce4a4a

    # Key bindings
    bindsym $modifier+Return exec $terminal
    bindsym $modifier+Shift+Return exec $terminal -e tmux
    bindsym $modifier+d exec $menu
    bindsym $modifier+Shift+q kill
    bindsym $modifier+Shift+e exec swaynag -t warning -m 'Exit Sway?' -b 'Yes' 'swaymsg exit'
    bindsym $modifier+h focus left
    bindsym $modifier+j focus down
    bindsym $modifier+k focus up
    bindsym $modifier+l focus right
    bindsym $modifier+Left focus left
    bindsym $modifier+Down focus down
    bindsym $modifier+Up focus up
    bindsym $modifier+Right focus right
    bindsym $modifier+Shift+h move left 30
    bindsym $modifier+Shift+j move down 30
    bindsym $modifier+Shift+k move up 30
    bindsym $modifier+Shift+l move right 30
    bindsym $modifier+Shift+Left move left
    bindsym $modifier+Shift+Down move down
    bindsym $modifier+Shift+Up move up
    bindsym $modifier+Shift+Right move right
    bindsym $modifier+1 workspace number 1
    bindsym $modifier+2 workspace number 2
    bindsym $modifier+3 workspace number 3
    bindsym $modifier+4 workspace number 4
    bindsym $modifier+5 workspace number 5
    bindsym $modifier+6 workspace number 6
    bindsym $modifier+7 workspace number 7
    bindsym $modifier+8 workspace number 8
    bindsym $modifier+9 workspace number 9
    bindsym $modifier+0 workspace number 10
    bindsym $modifier+Shift+1 move container to workspace number 1
    bindsym $modifier+Shift+2 move container to workspace number 2
    bindsym $modifier+Shift+3 move container to workspace number 3
    bindsym $modifier+Shift+4 move container to workspace number 4
    bindsym $modifier+Shift+5 move container to workspace number 5
    bindsym $modifier+Shift+6 move container to workspace number 6
    bindsym $modifier+Shift+7 move container to workspace number 7
    bindsym $modifier+Shift+8 move container to workspace number 8
    bindsym $modifier+Shift+9 move container to workspace number 9
    bindsym $modifier+Shift+0 move container to workspace number 10
    bindsym $modifier+b splith
    bindsym $modifier+v splitv
    bindsym $modifier+f fullscreen toggle
    bindsym $modifier+t split toggle
    bindsym $modifier+Shift+space floating toggle
    bindsym $modifier+space focus mode_toggle
    bindsym $modifier+o sticky toggle
    bindsym $modifier+r mode "resize"
    mode "resize" {
        bindsym h resize shrink width 10px
        bindsym j resize grow height 10px
        bindsym k resize shrink height 10px
        bindsym l resize grow width 10px
        bindsym Left resize shrink width 10px
        bindsym Down resize grow height 10px
        bindsym Up resize shrink height 10px
        bindsym Right resize grow width 10px
        bindsym Escape mode "default"
        bindsym Return mode "default"
    }
    bindsym $modifier+Tab workspace back_and_forth
    bindsym $modifier+g workspace prev
    bindsym $modifier+Escape workspace prev
    bindsym $modifier+Shift+Escape reload
    bindsym $modifier+n exec $terminal -e newsboat
    bindsym $modifier+i exec $terminal -e htop
    bindsym $modifier+Shift+w exec google-chrome-stable
    bindsym $modifier+Shift+x exec systemctl poweroff
    bindsym $modifier+c exec slack
    bindsym $modifier+Shift+c exec keybase
    bindsym $modifier+e exec discord
    bindsym $modifier+Shift+p exec keepassxc
    bindsym $modifier+u [title="dropdown tmux"] scratchpad show; [title="dropdown tmux"] move position center
    bindsym Print exec grim ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
    bindsym Shift+Print exec grim -g "$(slurp)" ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
    bindsym $modifier+z gaps outer current plus 5
    bindsym $modifier+Shift+z gaps outer current minus 5
    bindsym $modifier+Shift+t gaps inner current set 15; gaps outer current set 15
    bindsym $modifier+Shift+d gaps inner current set 0; gaps outer current set 0

    bindsym ctrl+space exec dunstctl close
    bindsym ctrl+shift+space exec dunstctl close-all
    bindsym ctrl+grave exec dunstctl history-pop
    bindsym ctrl+shift+period exec dunstctl context

    bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
    bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
    bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
    bindsym XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle
    bindsym XF86MonBrightnessDown exec brightnessctl set 5%-
    bindsym XF86MonBrightnessUp exec brightnessctl set 5%+
    bindsym XF86AudioPlay exec playerctl play-pause
    bindsym XF86AudioNext exec playerctl next
    bindsym XF86AudioPrev exec playerctl previous

    focus_follows_mouse yes
    mouse_warping output

    gaps inner 15
    gaps outer 15
    smart_gaps on
    smart_borders on

    input * {
        xkb_options caps:ctrl_modifier
        repeat_delay 300
        repeat_rate 30
    }

    # Window rules
    for_window [title="dropdown tmux"] floating enable, resize set 850 600, move scratchpad, border pixel 3
    for_window [title="dropdown math"] floating enable, resize set 800 300, move scratchpad, border pixel 3
    for_window [class="Gimp"] move to workspace 5
    for_window [class="Thunderbird"] move to workspace 9
    for_window [window_role="pop-up"] floating enable
    for_window [window_role="bubble"] floating enable
    for_window [window_role="task_dialog"] floating enable
    for_window [window_role="Preferences"] floating enable
    for_window [window_type="dialog"] floating enable
    for_window [window_type="menu"] floating enable
    for_window [app_id="pavucontrol"] floating enable, resize set 800 600, move position center

    bar {
        status_command ${pkgs.i3status}/bin/i3status

        position bottom
        height 30
        font pango:FuraCode Nerd Font Mono 10
        separator_symbol " │ "
        colors {
            background #121015
            statusline #d8d8de
            separator #3c3242

            focused_workspace  #9a76b3 #9a76b3 #121015
            active_workspace   #3c3242 #3c3242 #d8d8de
            inactive_workspace #1e1a22 #1e1a22 #3c3242
            urgent_workspace   #ce4a4a #ce4a4a #d8d8de

            binding_mode       #6e7eb0 #6e7eb0 #121015
        }
        tray_output none
    }

    exec --no-startup-id bash -c 'swaybg -i /home/matt_burdan/src/dotfiles/misc/wp3839746-prism-razer-wallpapers.png -m fill'
    exec --no-startup-id ghostty -T "dropdown tmux" -e tmux
    exec --no-startup-id slack --no-sandbox
    exec --no-startup-id keybase-gui --no-sandbox
    exec_always --no-startup-id ~/.local/bin/start-dunst.sh

    workspace_auto_back_and_forth yes
  '';

  home.file.".local/bin/start-dunst.sh" = {
    text = ''
      #!/bin/sh
      export DISPLAY=:0
      export GDK_BACKEND=x11
      exec ${pkgs.dunst}/bin/dunst
    '';
    executable = true;
  };

  home.file.".local/bin/play-sound.sh" = {
    text = ''
      #!/bin/sh
      ${pkgs.pulseaudio}/bin/paplay /home/matt_burdan/src/dotfiles/misc/lttp.wav
    '';
    executable = true;
  };
}
