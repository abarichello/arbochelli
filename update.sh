#!/bin/bash

git pull -r origin master && \
haxe src/build.hxml && \

DOMAIN=arbochelli.me \
DOMAIN2=arbochelli.download \
ONION_ADDR=http://basssssxls7b72rf6b2nngxcwhndx6r2k42bcbyx6dkeps7ilh3nwlqd.onion \
caddy reload && \

curl 'https://www.youtube.com/feeds/videos.xml?channel_id=UCQyPHw4V7du8Fx-o12_fudw' > static/yt-rss.xml && \
date -u +"%d-%m-%Y %H:%M:%S %Z" > static/update.txt && \
git log --format=reference --no-decorate -n1 >> static/update.txt
