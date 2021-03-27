package src;

import js.Browser;

function main() {
    src.Youtube.getRSSFeed();
    src.Template.replaceDash();
    src.Template.bindEvents();
    src.Template.initFilter();
    src.Template.getFilterElement().focus();
    for (t in Browser.document.getElementsByTagName("time")) {
        src.Template.localizeDateTime(t);
    }
    #if debug
    trace('Running in debug mode');
    #end
}
