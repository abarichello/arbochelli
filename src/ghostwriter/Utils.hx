package src.ghostwriter;

import haxe.xml.Access;

using StringTools;

#if debug
var rssFilename = "test-rss.xml";
#else
var rssFilename = "yt-rss.xml";
#end

final remove = [
    "- ",
    ",",
    "!",
];

final replace = [
    " ",
    "'"
];

inline function assert(bool: Bool, str: String) {
    if (!bool) {
        trace('Error: ${str}');
        Sys.exit(-1);
    }
}

inline function getFeedRawTitle(feed: Access) {
    return feed.node.title.innerData.replace(" [Bass Tabs/Sheet]", "");
}

inline function getFeedFilename(feed: Access) {
    var title = getFeedRawTitle(feed).toLowerCase();
    for (r in remove) {
        title = title.replace(r, "");
    }
    for (r in replace) {
        title = title.replace(r, "-");
    }
    return title;
}
