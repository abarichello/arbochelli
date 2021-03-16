#!/bin/bash

git pull -r origin master && \
haxe src/build.hxml && \
# todo: build hexo

DOMAIN=arbochelli.me \
DOMAIN2=arbochelli.download \
ONION_ADDR=http://basssssxls7b72rf6b2nngxcwhndx6r2k42bcbyx6dkeps7ilh3nwlqd.onion \
caddy reload && \
curl 'https://www.youtube.com/feeds/videos.xml?channel_id=UCQyPHw4V7du8Fx-o12_fudw' > static/yt-rss.xml && \

printf "Info|Value\n-|-\n**Last updated**|%s\n**Last commit**|%s\n**Repo size**|%s\n**Disk size**|%s" \
    "$(date -u +"%d-%m-%Y %H:%M:%S %Z")" \
    "$(git log --format=reference --no-decorate -n1)" \
    "$(git count-objects -vH | awk '{if (NR==5) print $2$3}')" \
    "$(du -sh . | awk '{print $1}')" \
    > static/status.md && \
    pandoc -s static/status.md -c static/template.css --metadata title="status" -o static/status.html
