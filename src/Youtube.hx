package src;

import haxe.xml.Parser;
import haxe.xml.Access;
import haxe.http.HttpJs;
import js.lib.Date;
import js.Browser.location;
import js.Browser.document;

typedef ParseResults = {
    totalVideos: Int,
    videos: Array<{
        title: String,
        link: String,
        thumbnail: String,
        published: String,
    }>,
}

function getRSSFeed() {
    final req = new HttpJs(src.Const.FEED_URL);
    req.async = true;
    req.onData = onData;
    req.onError = onError;
    req.request(false);
}

function onError(err: String) {
    trace(err);
}

function onData(feed: String) {
    updateLatestVideos(parseFeed(feed));
}

function parseFeed(feed: String): ParseResults {
    feed = StringTools.replace(feed, "\n  ", "");
    final xml = Parser.parse(feed);
    final entries = new Access(xml.firstElement()).nodes.entry;
    final videos = [for (i in 0...5)
        {
            title: StringTools.replace(entries[i].node.title.innerData, " [Bass Tabs/Sheet]", ""),
            link: entries[i].node.link.att.href,
            thumbnail: entries[i].node.resolve("media:group").node.resolve("media:description").innerData,
            published: new Date(entries[i].node.published.innerData).toLocaleDateString(),
        }
    ];
    return {
        totalVideos: entries.length,
        videos: videos,
    };
}

function updateLatestVideos(results: ParseResults) {
    if (location.pathname == "/") {
        updateTotalText(results.totalVideos);
    }

    final videosHTML = results.videos.map((video) -> '<a href="${video.link}" title="Published: ${video.published}"><u>${video.title}</u></a>');
    document.getElementById("recent-videos").innerHTML = '<b>Recent videos: ${videosHTML.join(" | ")}</b>';
}

function updateTotalText(totalScores: Int) {
    document.getElementById("total-text").innerHTML = '<b>${Std.string(totalScores)}</b> videos';
}
