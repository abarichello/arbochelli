package src.ghostwriter;

import sys.io.File;

function generateStatusFile() {
    var map: Map<String, String> = [
        "Last updated" => "date -u +'%d-%m-%Y %H:%M:%S %Z'",
        "Last commit" => "git log --format=short --no-decorate -n1 --oneline",
        "Repo size" => "git count-objects -vH | awk '{if (NR==5) print $2$3}'",
        "Disk size" => "du -sh . | awk '{print $1}'",
        "Total PDFs" => "ls -1 pdf | wc -l",
        "Total blog posts" => "ls -1 blog/source/_posts/ | wc -l",
    ];
    var markdown = "Info|Value\n-|-\n";
    for (txt in map.keys()) {
        final cmd = map.get(txt);
        if (cmd != null) {
            final process = new sys.io.Process(cmd);
            Utils.assert(process.exitCode() == 0, "Exit code different than zero");
            markdown += '**$txt**|${process.stdout.readLine()}\n';
        }
    }
    File.saveContent('static/status.md', markdown);
    trace("Saved status.md");
}
