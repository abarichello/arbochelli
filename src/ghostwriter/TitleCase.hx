package src.ghostwriter;

import haxe.io.Input;

using StringTools;

inline function titlecase(title: String): String {
    final diacritics = ["ê" => "e"];
    for (diacritic in diacritics.keyValueIterator()) {
        if (title.contains(diacritic.key)) {
            title = title.replace(diacritic.key, diacritic.value);
        }
    }
    final remove = ~/[\s~`!@#$%^&*()\-_+=[\]{}|\\;:"'<>,.?\/]+/g;
    final multipleDashes = ~/-+/;
    final trailingAndLeadingSeparator = ~/^-+|-+$/g;
    title = remove.replace(title, "-");
    title = multipleDashes.replace(title, "-");
    return trailingAndLeadingSeparator.replace(title, "").toLowerCase();
}

#if TITLECASE_TEST
function main() {
    Sys.stdout().writeString("Type the title: ");
    Sys.stdout().flush();
    final input = Sys.stdin().readLine();
    Utils.assert(input.length > 0, "Provide a non-empty title");
    Sys.stdout().writeString(titlecase(input).replace("-pdf", ""));
    Sys.stdout().flush();
}
#end
