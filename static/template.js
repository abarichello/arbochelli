replaceDash();

var filterEl = document.getElementById('filter');
filterEl.focus();

function replaceDash() {
    const elems = document.querySelectorAll('span.name');
    for (el of elems) {
        el.textContent = el.textContent.replace(/_/g, " ");
    }
}

function initFilter() {
    if (!filterEl.value) {
        var filterParam = new URL(window.location.href).searchParams.get('filter');
        if (filterParam) {
            filterEl.value = filterParam;
        }
    }
    filter();
}

function filter() {
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
}

function localizeDatetime(e, index, ar) {
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
    e.textContent = d.toLocaleString([], { day: "2-digit", month: "2-digit", year: "numeric", hour: "2-digit", minute: "2-digit" });
}

var timeList = Array.prototype.slice.call(document.getElementsByTagName("time"));
timeList.forEach(localizeDatetime);
