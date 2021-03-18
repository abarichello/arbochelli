// Generate a blog post from a XML file, should be run from the root folder
package src.ghostwriter;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import haxe.xml.Parser;
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
    return getFeedRawTitle(feed).toLowerCase().replace("- ", "").replace(" ", "-");
}

function readRSSFeed(): Access {
    var feed = File.getContent("./static/" + rssFilename);
    var xml = Parser.parse(feed);
    var lastEntry = new Access(xml.firstElement()).nodes.entry[0];
    return lastEntry;
}

function shouldPost(lastEntry: Access): Bool {
    trace("Starting 'should post' check");
    var filename = getFeedFilename(lastEntry) + ".md";
    var posts = FileSystem.readDirectory("./blog/source/_posts/");
    var entryDescription = lastEntry.node.resolve("media:group").node.resolve("media:description").innerData;

    var shouldPost = entryDescription.contains("#bass");
    var newPost = !posts.contains(filename);
    var res = shouldPost && newPost;

    trace('Decided that ${filename} should ${res ? "" : "not "}be posted');
    return res;
}

function createPost(title: String) {
    var res = Sys.command('hexo new sheet "${title}" --cwd blog');
    assert(res == 0, "Sys command returned non-zero code");
}

function createReplaceMap(lastEntry: Access): Map<String, String> {
    var title = getFeedRawTitle(lastEntry);
    var description: String = lastEntry.node.resolve("media:group").node.resolve("media:description").innerData;

    var urlLine = description.split("\n")[0];
    var pdfRegex = ~/https:\/\/.+/;
    pdfRegex.match(urlLine);
    var pdfURL = pdfRegex.matched(0).replace("/p", "");

    var notesRegex = ~/Notes:.+/;
    notesRegex.match(description);
    var notes = notesRegex.matched(0).replace("Notes: ", "");

    var searchTags = [
        "#anime",
        "#brazil",
        "#game",
        "#indie"
    ];
    var tag = searchTags.filter((t) -> description.contains(t))[0].substr(1);
    var youtubeHash = lastEntry.node.resolve("yt:videoId").innerData;

    return [
        "$title" => title,
        "$notes" => notes,
        "$youtube" => youtubeHash,
        "$pdf" => pdfURL,
        "$tag" => tag,
    ];
}

function templatePost(title: String, replaceMap: Map<String, String>) {
    var path = "./blog/source/_posts/" + title + ".md";
    var content = File.getContent(path);
    var iter = replaceMap.keyValueIterator();
    while (iter.hasNext()) {
        var current = iter.next();
        content = content.replace(current.key, current.value);
    }
    File.saveContent(path, content);
    trace("Saved templated contents");
}

function main() {
    var lastEntry = readRSSFeed();
    if (shouldPost(lastEntry)) {
        var filename = getFeedFilename(lastEntry);
        var rawTitle = getFeedRawTitle(lastEntry);
        trace("Posting last entry: " + rawTitle);
        createPost(rawTitle);
        var map = createReplaceMap(lastEntry);
        templatePost(filename, map);
    }
}
