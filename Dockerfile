FROM haxe:4.2.1-buster as haxe

COPY . /arbochelli
WORKDIR /arbochelli

RUN git remote set-url origin "https://github.com/aBARICHELLO/arbochelli" && \
    git pull origin master && \
    git submodule update --recursive && \
    curl 'https://www.youtube.com/feeds/videos.xml?channel_id=UCQyPHw4V7du8Fx-o12_fudw' > static/yt-rss.xml && \
    haxe src/build/all.hxml

FROM node:15.12.0-buster as node

COPY --from=haxe /arbochelli /arbochelli
WORKDIR /arbochelli/blog

RUN yarn && \
    yarn global add hexo-cli && \
    rm -rf /public/css && \
    hexo generate && \
    printf "Info|Value\n-|-\n**Last updated**|%s\n**Last commit**|%s\n**Repo size**|%s\n**Disk size**|%s\n**Total posts**|%s" \
    "$(date -u +"%d-%m-%Y %H:%M:%S %Z")" \
    "$(git log --format=reference --no-decorate -n1)" \
    "$(git count-objects -vH | awk '{if (NR==5) print $2$3}')" \
    "$(du -sh . | awk '{print $1}')" \
    "$(ls -f blog/source/_posts/ | wc -l)" \
    > ../static/status.md

FROM caddy:2.3.0-alpine as caddy

COPY --from=haxe /arbochelli /arbochelli
WORKDIR /arbochelli/

CMD ["caddy", "run"]
