{ pkgs, ... }:

{
  home.file.".local/bin/lock-screen.sh" = {
    text = ''
      #!/usr/bin/env bash
      set -e

      pkill -f swaylock || true

      ${pkgs.swayidle}/bin/swayidle \
        timeout 5 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"' &

      SWAYIDLE_PID=$!

      ${pkgs.swaylock-effects}/bin/swaylock \
        --screenshots \
        --clock \
        --indicator \
        --indicator-radius 100 \
        --indicator-thickness 7 \
        --effect-blur 7x5 \
        --effect-vignette 0.5:0.5 \
        --ring-color 9a76b3 \
        --key-hl-color c29e47 \
        --line-color 00000000 \
        --inside-color 12101588 \
        --separator-color 00000000 \
        --grace 2 \
        --fade-in 0.2

      kill $SWAYIDLE_PID 2>/dev/null || true
    '';
    executable = true;
  };

  home.file.".local/bin/play-sound.sh" = {
    text = ''
      #!/usr/bin/env sh
      ${pkgs.pulseaudio}/bin/paplay /home/burdz/src/dotfiles/misc/lttp.wav
    '';
    executable = true;
  };

  home.file.".local/bin/listening.sh" = {
    text = ''
      #!/usr/bin/env bash
      set -e
      if (( $# == 0 )); then
        lsof -n -i4TCP | grep LISTEN
      else
        lsof -n -i4TCP:"$1" | grep LISTEN
      fi
    '';
    executable = true;
  };

  home.file.".local/bin/dirsize" = {
    text = ''
      #!/usr/bin/env bash
      du -sh "$1"
    '';
    executable = true;
  };
}
