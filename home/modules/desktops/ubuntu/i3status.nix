{ ... }:

{
  xdg.configFile."i3status/config".text = ''
    general {
            colors = true
            interval = 1
            color_good = "#2AA198"
            color_bad = "#DC322F"
            color_degraded = "#B58900"
    }

    order += "disk /"
    order += "run_watch DHCP"
    order += "run_watch VPN"
    order += "wireless wlp2s0"
    order += "ethernet enp1s0f0"
    order += "battery 0"
    order += "load"
    order += "cpu_temperature 0"
    order += "memory"
    order += "volume master"
    order += "tztime local"

    wireless wlp2s0 {
            format_up = "  %quality at %essid %ip"
            format_down = "  down"
    }

    ethernet enp1s0f0 {
            format_up = "󰈀  %ip %speed"
            format_down = "󰈀  down"
    }

    battery 0 {
            format = "%status %percentage %remaining"
            format_down = "No battery"
            status_chr = "⚡  CHR"
            status_bat = "🔋 BAT"
            status_full = "  FULL"
            path = "/sys/class/power_supply/BAT%d/uevent"
            low_threshold = 10
    }

    run_watch DHCP {
            pidfile = "/var/run/dhclient*.pid"
    }

    run_watch VPN {
            pidfile = "/var/run/openvpn*.pid"
    }

    tztime local {
            format = "  %a %b %d %H:%M:%S "
    }

    load {
            format = "  %1min"
    }

    memory {
            format = "  %used / %total"
            threshold_degraded = "10%"
            format_degraded = "MEMORY < %available"
    }

    disk "/" {
            format = "  %avail/%total"
    }

    cpu_temperature 0 {
            format = "  %degrees °C"
    }

    volume master {
            format = "🔊  %volume"
            format_muted = "🔇  %volume"
            device = "pulse"
            mixer = "Master"
            mixer_idx = 0
    }
  '';
}
