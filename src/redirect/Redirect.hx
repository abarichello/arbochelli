package src.redirect;

import haxe.http.HttpJs;
import haxe.Json;
import js.html.URLSearchParams;
import js.Browser.window;
import js.Browser.location;
import js.Browser.document;

using StringTools;

final log = !location.host.contains("localhost");

function main() {
    window.onload = () -> redirect();
}

function redirect() {
    final urlParams = new URLSearchParams(location.search);
    final redir = urlParams.get("r");
    if (redir != "") {
        document.getElementById("text").textContent = 'Redirecting to ${redir}';
        if (log) {
            umami(redir);
        } else {
            trace('Redirecting to ${redir}');
            window.location.assign(src.Const.DOMAIN_URL + redir);
        }
    } else {
        document.getElementById("text").textContent = "No redirect";
    }
}

function umami(redir: String) {
    final language = window.navigator.language;
    final hostname = location.hostname;
    final referrer = document.referrer;
    final screen = '${window.screen.width}x${window.screen.height}';

    final req = new HttpJs(src.Const.COLLECT_URL);
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
