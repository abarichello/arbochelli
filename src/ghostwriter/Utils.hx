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

inline function getFeedRawTitle(feed: Access): String {
    final title = feed.node.title.innerData;
    final removalIndex = title.lastIndexOf("[") - 1;
    return title.substring(0, removalIndex);
}

inline function getFeedFilename(feed: Access): String {
    final title = getFeedRawTitle(feed);
    return TitleCase.titlecase(title);
}
