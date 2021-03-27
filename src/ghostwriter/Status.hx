package src.ghostwriter;

import sys.io.File;

function generateStatusFile() {
    var commands = [
        "date -u +'%d-%m-%Y %H:%M:%S %Z'",
        "git log --format=short --no-decorate -n1 --oneline",
        "git count-objects -vH | awk '{if (NR==5) print $2$3}'",
        "du -sh . | awk '{print $1}'",
        "ls -1 blog/source/_posts/ | wc -l",
    ];
    final output = [];
    for (cmd in commands) {
        final process = new sys.io.Process(cmd);
        output.push(process.stdout.readLine());
    }
    final markdown = '
Info|Value
-|-
**Last updated**|${output[0]}
**Last commit**|${output[1]}
**Repo size**|${output[2]}
**Disk size**|${output[3]}
**Total posts**|${output[4]}
';
    File.saveContent('static/status.md', markdown);
    trace("Saved status.md");
}
