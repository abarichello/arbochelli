package src.ghostwriter;

import haxe.xml.Access;

using StringTools;

#if debug
var rssFilename = "test-rss.xml";
#else
var rssFilename = "yt-rss.xml";
#end

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
    final title = getFeedRawTitle(feed).toLowerCase();
    final remove = ~/[\s~`!@#$%^&*()\-_+=[\]{}|\\;:"'<>,.?\/]+/g;
    final multipleDashes = ~/-+/;
    final trailingAndLeadingSeparator = ~/^-+|-+$/g;

    final removedSpecial = remove.replace(title, "-");
    final removedContiguous = multipleDashes.replace(removedSpecial, "-");
    return trailingAndLeadingSeparator.replace(removedContiguous, "");
}
