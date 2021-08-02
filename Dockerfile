FROM haxe:4.2.1-alpine as build

RUN apk add --no-cache curl git git-lfs nodejs npm \
    && npm install --global yarn \
    && yarn global add hexo-cli

COPY . /arbochelli
WORKDIR /arbochelli

RUN git lfs install \
    && git config pull.ff only \
    && git config user.email "webmaster@arbochelli.me" \
    && git config user.name "Ghostwriter" \
    && git fetch \
    && git reset --hard origin/master \
    && git submodule foreach git pull origin master \
    && curl 'https://www.youtube.com/feeds/videos.xml?channel_id=UCQyPHw4V7du8Fx-o12_fudw' > static/yt-rss.xml \
    && haxelib install src/build/*.hxml --always \
    && haxe src/build/all.hxml

WORKDIR /arbochelli/blog

RUN yarn \
    && yarn clean \
    && yarn build \
    && git add source/_posts/ \
    && (git commit -m $(ls -1t source/_posts/ | head -1) || true) \
    && git push token master

FROM caddy:2.3.0-alpine as caddy

COPY --from=build /arbochelli /arbochelli
WORKDIR /arbochelli

CMD ["caddy", "run"]
