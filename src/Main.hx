package src;

import js.Browser;

class Main {
    static function main() {
        src.Template.bindEvents();
        src.Template.initFilter();
        src.Template.getFilterElement().focus();
        src.Template.replaceDash();
        for (t in Browser.document.getElementsByTagName("time")) {
            src.Template.localizeDateTime(t);
        }
    }
}