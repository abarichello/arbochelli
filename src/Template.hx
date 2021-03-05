package src;

import js.Syntax;
import js.Browser;
import js.html.URL;
import js.Browser.document;

function replaceDash() {
    var elements = document.querySelectorAll("span.name");
    for (el in elements) {
        el.textContent = el.textContent.split("_").join(" ");
    }
}

// Caddy JS functions defined in the default browser template from the docs

function bindEvents() {
    getFilterElement().onkeyup = (event) -> filter();
}

function getFilterElement() {
    return document.getElementById('filter');
}

function initFilter() {
    var filterEl = getFilterElement();
    if (filterEl.itemValue == null) {
        var filterParam = new URL(Browser.location.href).searchParams.get('filter');
        if (filterParam != "") {
            filterEl.itemValue = filterParam;
        }
    }
    filter();
}

@:native("filter")
function filter() {
    Syntax.code("
    var filterEl = document.getElementById('filter');
    var q = filterEl.value.trim().toLowerCase();
    var elems = document.querySelectorAll('tr.file');
    elems.forEach(function (el) {
        if (!q) {
            el.style.display = '';
            return;
        }
        var nameEl = el.querySelector('.name');
        var nameVal = nameEl.textContent.trim().toLowerCase();
        if (nameVal.indexOf(q) !== -1) {
            el.style.display = '';
        } else {
            el.style.display = 'none';
        }
    });
    ");
}

@:native("localizeDateTime")
function localizeDateTime(e) {
    Syntax.code("
    if (e.textContent === undefined) {
        return;
    }
    var d = new Date(e.getAttribute('datetime'));
    if (isNaN(d)) {
        d = new Date(e.textContent);
        if (isNaN(d)) {
            return;
        }
    }
    e.textContent = d.toLocaleString([], { day: \"2-digit\", month: \"2-digit\", year: \"numeric\", hour: \"2-digit\", minute: \"2-digit\" });
    ");
}
