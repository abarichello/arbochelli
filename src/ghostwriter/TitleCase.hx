package src.ghostwriter;

import haxe.io.Input;

inline function titlecase(title: String): String {
    final remove = ~/[\s~`!@#$%^&*()\-_+=[\]{}|\\;:"'<>,.?\/]+/g;
    final multipleDashes = ~/-+/;
    final trailingAndLeadingSeparator = ~/^-+|-+$/g;

    final removedSpecial = remove.replace(title, "-");
    final removedContiguous = multipleDashes.replace(removedSpecial, "-");
    return trailingAndLeadingSeparator.replace(removedContiguous, "").toLowerCase();
}

#if TITLECASE_TEST
function main() {
    Sys.stdout().writeString("Type the title: ");
    Sys.stdout().flush();
    final input = Sys.stdin().readLine();
    Utils.assert(input.length > 0, "Provide a non-empty title");
    Sys.stdout().writeString(titlecase(input));
    Sys.stdout().flush();
}
#end
