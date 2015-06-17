#!/bin/env python
###  Przemyslaw Ozgo (2015)
# Thanks to Vicente Dominguez
#
# Options:
#
# -a "accepted conn"
# -a "max listen queue"
# -a "listen queue len"
# -a "idle processes"
# -a "active processes"
# -a "total processes"
# -a "slow requests"
#

import simplejson as json
import urllib2, base64, sys, getopt
import re

##

def Usage ():
        print "Usage: getPhpInfo.py -h 127.0.0.1 -p 80 -a [accepted conn|max listen queue|listen queue len|idle processes|active processes|total processes|slow requests]"
        sys.exit(2)

##

def main ():

    # Default values
    host = "localhost"
    port = "80"
    getInfo = "None"

    if len(sys.argv) < 2:
        Usage()

    try:
            opts, args = getopt.getopt(sys.argv[1:], "h:p:a:")
    except getopt.GetoptError:
                Usage()

    # Assign parameters as variables
    for opt, arg in opts :
        if opt == "-h" :
                host = arg
        if opt == "-p" :
                port = arg
        if opt == "-a" :
                getInfo = arg

    url="http://" + host + ":" + port + "/fpm_status?json"
    request = urllib2.Request(url)
    try:
        result = urllib2.urlopen(request)
        buffer = json.loads(result.read())
    except:
        print "-1"
        sys.exit(1)
    print buffer.pop(getInfo,'unknown')
    sys.exit(0)

if __name__ == "__main__":
    main()