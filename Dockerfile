FROM haxe:4.2.1-buster as haxe

COPY . /arbochelli
WORKDIR /arbochelli

RUN git config user.email "webmaster@arbochelli.me" && \
    git config user.name "Barichello" && \
    (git pull token master || true) && \
    (git submodule update --recursive || true) && \
    curl 'https://www.youtube.com/feeds/videos.xml?channel_id=UCQyPHw4V7du8Fx-o12_fudw' > static/yt-rss.xml && \
    haxe src/build/all.hxml

FROM node:15.12.0-alpine as node

RUN apk --no-cache add git && \
    yarn global add hexo-cli

COPY --from=haxe /arbochelli /arbochelli
WORKDIR /arbochelli/blog

RUN yarn && \
    rm -rf public/css && \
    hexo generate && \
    git add source/_posts/ && (git commit -m 'Publish new post' || true) && git push token master && \
    printf "Info|Value\n-|-\n**Last updated**|%s\n**Last commit**|%s\n**Repo size**|%s\n**Disk size**|%s\n**Total posts**|%s" \
    "$(date -u +'%d-%m-%Y %H:%M:%S %Z')" \
    "$(git log --format=short --no-decorate -n1 --oneline)" \
    "$(git count-objects -vH | awk '{if (NR==5) print $2$3}')" \
    "$(du -sh . | awk '{print $1}')" \
    "$(ls -1 source/_posts/ | wc -l)" \
    > ../static/status.md

FROM caddy:2.3.0-alpine as caddy

COPY --from=node /arbochelli /arbochelli
WORKDIR /arbochelli/

CMD ["caddy", "run"]
