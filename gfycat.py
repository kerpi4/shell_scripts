#!/usr/bin/env python

from gfycat.client import GfycatClient
from gfycat.error import GfycatClientError
import sys

client = GfycatClient()
arg = sys.argv[0:]

check = client.check_link(arg)
if check['urlKnown'] != False:
    print(check['urlKnown'])
    exit()

if arg.startswith('http://') or arg.startswith('https://'): 
    link = client.upload_from_url(arg)
else:
    link = client.upload_from_file(arg)

webm = link['webmUrl']
gif = link['gifUrl']

print('Webm link : ' + webm)
print('Gif link : ' + gif)
