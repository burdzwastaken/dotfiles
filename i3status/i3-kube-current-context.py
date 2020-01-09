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
import subprocess
from kubernetes import config

def get_context():
    """ Get the current Kubernetes context. """
    colour = "#46aede"
    try:
        config.load_kube_config(
            os.path.join(os.environ["HOME"], '.kube/config'))
        currentContext = config.list_kube_config_contexts()[1]['name']
        if 'prod' in currentContext:
            colour = "#eb4509"
        return currentContext, colour
    except Exception:
        return "context.TODO()", "#5fffaf"

# TODO(burdz): add support for multiple KinD clusters <09-01-20> #
def get_kind_cluster():
    """ Is KinD running? :>? """
    kindCluster = subprocess.check_output("kind get clusters", shell=True).strip().decode('utf-8')
    if not kindCluster:
        return "not your kind :>", "#5fffaf"
    else:
        return kindCluster, "#46aede"

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
        currentContext, contextColour = get_context()
        kindCluster, kindColour = get_kind_cluster()
        # j.insert(0, {'full_text' : '' , 'name' : '', 'color' : ''})
        j.insert(0, {'full_text' : '☸ %s' % currentContext, 'name' : '☸', 'color' : '%s' % contextColour})
        j.insert(0, {'full_text' : '☸ %s' % kindCluster, 'name' : '☸', 'color' : '%s' % kindColour})
        # and echo back new encoded json
        print_line(prefix+json.dumps(j))
