#!/bin/bash
#!/bin/bash

#------------------------------------------------------------------------------
# File:   $HOME/dotfiles/scripts/iptables.sh
# Author: Matt Burdan <burdz@burdz.net>
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# bootstrapz
#------------------------------------------------------------------------------

# flush all existing rules
iptables -F

# drop suspicious traffic
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# allow loopback/established
iptables -A INPUT -i lo -j ACCEPT
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# open specific ports
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

# allow avahi/windows shit
iptables -A INPUT -p udp -m udp --dport 5353 -j ACCEPT

# chromecast
iptables -A INPUT -p tcp --dport 5556 -j ACCEPT
iptables -A INPUT -p tcp --dport 5558 -j ACCEPT

# allow UDP on all ephemeral ports for UPnP/SSDP
iptables -A INPUT -p udp --dport 32768:61000 -j ACCEPT

# Drop everything else
iptables -P INPUT DROP
