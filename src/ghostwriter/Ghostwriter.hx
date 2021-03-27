package src.ghostwriter;

import sys.io.File;
import sys.FileSystem;
import haxe.xml.Parser;
import haxe.xml.Access;
import src.ghostwriter.Utils;

using StringTools;

function readRSSFeed(): Access {
    final feed = File.getContent("./static/" + rssFilename);
    final xml = Parser.parse(feed);
    return new Access(xml.firstElement()).nodes.entry[0];
}

function shouldPost(lastEntry: Access): Bool {
    trace("Starting 'should post' check");
    final filename = getFeedFilename(lastEntry) + ".md";
    final posts = FileSystem.readDirectory("./blog/source/_posts/");
    final entryDescription = lastEntry.node.resolve("media:group").node.resolve("media:description").innerData;

    final shouldPost = entryDescription.contains("#bass");
    final newPost = !posts.contains(filename);
    final res = shouldPost && newPost;

    trace('Decided that ${filename} should ${res ? "" : "not "}be posted');
    return res;
}

function createPost(title: String) {
    final res = Sys.command('hexo new sheet "${title}" --cwd blog');
    assert(res == 0, "Sys command returned non-zero code");
}

function createReplaceMap(lastEntry: Access): Map<String, String> {
    final title = getFeedRawTitle(lastEntry);
    final description: String = lastEntry.node.resolve("media:group").node.resolve("media:description").innerData;

    final urlLine = description.split("\n")[0];
    final pdfRegex = ~/https:\/\/.+/;
    final pdfURL = pdfRegex.match(urlLine) ? pdfRegex.matched(0).replace("/p", "") : "";

    final notesRegex = ~/Notes:.+/;
    final notes = notesRegex.match(description) ? notesRegex.matched(0).replace("Notes: ", "") : "";

    final searchTags = [
        "#anime",
        "#brazil",
        "#game",
        "#indie"
    ];
    final tag = searchTags.filter((t) -> description.contains(t))[0].substr(1);
    final youtubeHash = lastEntry.node.resolve("yt:videoId").innerData;

    return [
        "$title" => title,
        "$notes" => notes,
        "$youtube" => youtubeHash,
        "$pdf" => pdfURL,
        "$tag" => tag,
    ];
}

function templatePost(title: String, replaceMap: Map<String, String>) {
    final path = "./blog/source/_posts/" + title + ".md";
    var content = File.getContent(path);
    final iter = replaceMap.keyValueIterator();
    for (key => value in iter) {
        content = content.replace(key, value);
    }
    File.saveContent(path, content);
    trace("Saved templated contents");
}

function ghostwrite() {
    final lastEntry = readRSSFeed();
    if (shouldPost(lastEntry)) {
        final filename = getFeedFilename(lastEntry);
        final rawTitle = getFeedRawTitle(lastEntry);
        trace("Posting last entry: " + rawTitle);
        createPost(rawTitle);
        final map = createReplaceMap(lastEntry);
        templatePost(filename, map);
    }
}

function main() {
    ghostwrite();
    Status.generateStatusFile();
}
