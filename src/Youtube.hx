package src;

import haxe.xml.Access;
import haxe.xml.Parser;
import haxe.http.HttpJs;

function getRSSFeed() {
    var req = new HttpJs(src.Const.FEED_URL);
    req.async = true;
    req.onData = parseFeed;
    req.onError = onError;
    req.request(false);
}

function parseFeed(feed: String) {
    feed = StringTools.replace(feed, "\n  ", "");
    var xml = Parser.parse(feed);
    var entries = new Access(xml.firstElement()).nodes.entry;

    var results = entries.map((entry) -> {
        return {
            title: StringTools.replace(entry.node.title.innerData, " [Bass Tab+Sheet]", ""),
            link: entry.node.link.att.href,
            thumbnail: entry.node.resolve("media:group").node.resolve("media:description").innerData,
        }
    });
    trace(results);
    return results;
}

function onError(err: String) {
    trace(err);
}
