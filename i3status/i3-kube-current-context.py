#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section.
# Then, in your ~/.i3/config, use:
#     status_command i3status | ~/.config/i3status/i3-kube-current-context.py
# In the 'bar' section.

import os
import sys
import json
from kubernetes import config

def get_context():
    """ Get the current Kubernetes context. """
    config.load_kube_config(
        os.path.join(os.environ["HOME"], '.kube/config'))

    currentContext = config.list_kube_config_contexts()[1]['name']
    colour = "#46aede"
    if 'prod' in currentContext:
        colour = "#eb4509"

    return currentContext, colour

def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()

def read_line():
    """ Interrupted respecting reader for stdin. """
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()

if __name__ == '__main__':
    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    while True:
        line, prefix = read_line(), ''
        # ignore comma at start of lines
        if line.startswith(','):
            line, prefix = line[1:], ','

        j = json.loads(line)
        # insert information into the start of the json, but could be anywhere
        # CHANGE THIS LINE TO INSERT SOMETHING ELSE
        currentContext, colour = get_context()
        # j.insert(0, {'full_text' : '' , 'name' : '', 'color' : ''})
        j.insert(0, {'full_text' : '☸ %s' % currentContext, 'name' : '☸', 'color' : '%s' % colour})
        # and echo back new encoded json
        print_line(prefix+json.dumps(j))
