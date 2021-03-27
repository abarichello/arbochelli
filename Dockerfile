FROM haxe:4.2.1-alpine as build

RUN apk add --no-cache curl git nodejs npm \
    && npm install --global yarn \
    && yarn global add hexo-cli

COPY . /arbochelli
WORKDIR /arbochelli

RUN git config pull.ff only \
    && git config user.email "webmaster@arbochelli.me" \
    && git config user.name "Barichello" \
    && git pull token master \
    && git submodule update --recursive \
    && curl 'https://www.youtube.com/feeds/videos.xml?channel_id=UCQyPHw4V7du8Fx-o12_fudw' > static/yt-rss.xml \
    && haxe src/build/all.hxml

WORKDIR /arbochelli/blog

RUN yarn \
    && yarn clean \
    && yarn build \
    && git add source/_posts/ \
    && (git commit -m 'Publish new post' || true) \
    && git push token master

FROM caddy:2.3.0-alpine as caddy

COPY --from=build /arbochelli /arbochelli
WORKDIR /arbochelli

CMD ["caddy", "run"]
