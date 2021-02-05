#!/bin/bash

cd ~/arbochelli && git pull -r origin master && DOMAIN=arbochelli.download caddy reload

