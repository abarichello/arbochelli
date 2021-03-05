package src.redirect;

import haxe.http.HttpJs;
import haxe.Json;
import js.html.URLSearchParams;
import js.Browser.window;
import js.Browser.location;
import js.Browser.document;

function main() {
    window.onload = () -> redirect();
}

function redirect() {
    var urlParams = new URLSearchParams(location.search);
    var redir = urlParams.get("r");
    if (redir != "") {
        document.getElementById("text").textContent = 'Redirecting to ${redir}';
        #if debug
        var log = true;
        #else
        var log = !StringTools.contains(location.host, "localhost");
        #end
        if (log) {
            umami(redir);
        }
    } else {
        document.getElementById("text").textContent = "No redirect";
    }
}

function umami(redir: String) {
    var language = window.navigator.language;
    var hostname = location.hostname;
    var referrer = document.referrer;
    var screen = '${window.screen.width}x${window.screen.height}';

    var req = new HttpJs(src.Const.COLLECT_URL);
    req.addHeader("Content-type", "application/json");
    req.onError = function(error: String) {
        throw error;
    };

    req.onData = (data) -> {
        window.location.assign(src.Const.DOMAIN_URL + redir);
    }

    req.setPostData(Json.stringify({
        type: "pageview",
        payload: {
            cache: null,
            website: "b485bc74-881e-4f53-a0e6-5ae113ff8e6e",
            hostname: hostname,
            screen: screen,
            language: language,
            referrer: referrer,
            url: redir,
        },
    }));

    req.request(true);
}
