package src.ghostwriter;

import sys.io.File;
import sys.FileSystem;
import haxe.xml.Parser;
import haxe.xml.Access;
import src.ghostwriter.Utils;

using StringTools;

function readRSSFeed(): Access {
    var feed = File.getContent("./static/" + rssFilename);
    var xml = Parser.parse(feed);
    return new Access(xml.firstElement()).nodes.entry[0];
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
    // TODO: Handle non-matching cases
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
    for (key => value in iter) {
        content = content.replace(key, value);
    }
    File.saveContent(path, content);
    trace("Saved templated contents");
}

function ghostwrite() {
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

function main() {
    ghostwrite();
    Status.generateStatusFile();
}
