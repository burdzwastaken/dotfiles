#!/usr/bin/python
"""
To use this to mimic the EC2 metadata service entirely, run it like:
  # where 'eth0' is *some* interface.  if i used 'lo:0' i got 5 second or so delays on response.
  sudo ifconfig eth0:0 169.254.169.254 netmask 255.255.255.255
  sudo ./mdserv 169.254.169.254:80
Then:
  wget -q http://169.254.169.254/latest/meta-data/instance-id -O -; echo
  curl --silent http://169.254.169.254/latest/meta-data/instance-id ; echo
  ec2metadata --instance-id

From: https://gist.github.com/smoser/1278651/936924869ecfaa489a4debc509852ff161b2e182
"""

import sys
import BaseHTTPServer

# output of: python -c 'import boto.utils; boto.utils.get_instance_metadata()'
md = {
 'ami-id': 'ami-3dd11d54',
 'ami-launch-index': '0',
 'ami-manifest-path': '(unknown)',
 'block-device-mapping': {'ami': '/dev/sda1',
                          'ephemeral0': '/dev/sdb',
                          'root': '/dev/sda1'},
 'hostname': 'ip-10-127-107-239.ec2.internal',
 'instance-action': 'none',
 'instance-id': 'i-a2547ac2',
 'instance-type': 't1.micro',
 'kernel-id': 'aki-825ea7eb',
 'local-hostname': 'ip-10-127-107-239.ec2.internal',
 'local-ipv4': '10.127.107.239',
 'mac': '12:31:38:10:88:01',
 'network': {
  'interfaces': {
   'macs': {
    '12:31:38:10:88:01': {
     'local-hostname': 'ip-10-127-107-239.ec2.internal',
     'local-ipv4s': '10.127.107.239',
     'mac': '12:31:38:10:88:01',
     'public-hostname': 'ec2-50-19-60-80.compute-1.amazonaws.com',
     'public-ipv4s': '50.19.60.80',
     'security-groups': 'default'
    }
   }
  }
 },
 'placement': {'availability-zone': 'us-east-1d'},
 'profile': 'default-paravirtual',
 'public-hostname': 'ec2-50-19-60-80.compute-1.amazonaws.com',
 'public-ipv4': '50.19.60.80',
 'public-keys': {
  'brickies': [
   'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA3I7VUf2l5gSn5uavROsc5HRDpZdQueUq5ozemNSj8T7enqKHOEaFoU2VoPgGEWC9RyzSQVeyD6s7APMcE82EtmW4skVEgEGSbDc1pvxzxtchBj78hJP6Cf5TCMFSXw+Fz5rF1dR23QDbN1mkHs7adr8GW4kSWqU7Q7NDwfIrJJtO7Hi42GyXtvEONHbiRPOe8stqUly7MvUoN+5kfjBM8Qqpfl2+FNhTYWpMfYdPUnE7u536WqzFmsaqJctz3gBxH9Ex7dFtrxR4qiqEr9Qtlu3xGn7Bw07/+i1D+ey3ONkZLN+LQ714cgj8fRS4Hj29SCmXp5Kt5/82cD/VN3NtHw== brickies',
   ''
  ]
 },
 'reservation-id': 'r-50258f3e',
 'security-groups': 'default'
}

ud = """#!/bin/sh
echo Hi World
"""

MD_TREE = {
	'latest' : { 'user-data' : ud, 'meta-data': md },
	'2009-04-04' : { 'user-data' : ud, 'meta-data': md },
	'2011-01-01' : { 'user-data' : ud, 'meta-data': md },
}

def fixup_pubkeys(pk_dict, listing):
	# if pk_dict is a public-keys dictionary as returned by boto
	# listing is boolean indicating if this is a listing or a item
	#
	# public-keys is messed up. a list of /latest/meta-data/public-keys/
	# shows something like: '0=brickies'
	# but a GET to /latest/meta-data/public-keys/0=brickies will fail
	# you have to know to get '/latest/meta-data/public-keys/0', then
	# from there you get a 'openssh-key', which you can get.
	# this hunk of code just re-works the object for that.
	i = -1
	mod_cur = {}
	for k in sorted(pk_dict.keys()):
		i = i+1
		if listing:
			mod_cur["%d=%s" % (i, k)] = ""
		else:
			mod_cur["%d" % i] = { "openssh-key": '\n'.join(pk_dict[k]) }
	return(mod_cur)

class myRequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):
	def do_GET(self):

		# set 'path' to "normalized" path, ie without leading
		# or trailing '/' and without double /
		toks = [i for i in self.path.split("/") if i != "" ]
		path = '/'.join(toks)

		cur = MD_TREE
		for tok in toks:
			if isinstance(cur, str):
				cur = None
				break
			cur = cur.get(tok, None)
			if cur == None:
				break
			if tok == "public-keys":
				cur = fixup_pubkeys(cur, toks[-1] == "public-keys")

		if cur == None:
			output = None
		elif isinstance(cur,str):
			output = cur
		else:
			mlist = []
			for k in sorted(cur.keys()):
				if isinstance(cur[k], str):
					mlist.append(k)
				else:
					mlist.append("%s/" % k)

			output = "\n".join(mlist)

		if cur:
			self.send_response(200)
			self.end_headers()
			self.wfile.write(output)
		else:
			self.send_response(404)
			self.end_headers()

		return

	def do_POST(self):
		return

def run_while_true(server_class=BaseHTTPServer.HTTPServer,
                   handler_class=BaseHTTPServer.BaseHTTPRequestHandler,
                   port=8001, ipaddr=''):
	"""
	This assumes that keep_running() is a function of no arguments which
	is tested initially and after each request.  If its return value
	is true, the server continues.
	"""
	server_address = (ipaddr, int(port))
	httpd = server_class(server_address, handler_class)
	httpd.serve_forever()

args = { }
args['handler_class'] = myRequestHandler
args['port'] = 8000
args['ipaddr'] = ''
if len(sys.argv) == 2:
	toks = sys.argv[1].split(":")
	if len(toks) == 1:
		# port only
		args['port'] = sys.argv[1]
	if len(toks) == 2:
		# host:port
		(args['ipaddr'],args['port']) = toks

print "listening on %s:%s" % (args['ipaddr'], args['port'])
run_while_true(**args)
# vi: ts=4 noexpandtab
