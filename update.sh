#!/bin/bash

cd ~/arbochelli && \
    git pull -r origin master && \
    DOMAIN=arbochelli.download \
    ONION_ADDR=http://basssssxls7b72rf6b2nngxcwhndx6r2k42bcbyx6dkeps7ilh3nwlqd.onion && \
    caddy reload && \
    date -u +"%d-%m-%y %H:%M:%S %Z" > static/update.txt
