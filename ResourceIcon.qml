import QtQuick

// Static SVG: no remote favicons, timers, shaders or per-frame rasterization.
Image {
    property color ink
    property bool installed: false
    property bool web: true
    sourceSize.width: 40; sourceSize.height: 40
    source: "data:image/svg+xml;utf8," + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="none" stroke="' + ink + '" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">' + (installed ? '<rect x="2" y="3" width="19" height="16" rx="3"/><path d="M2 8h19M5 5.5h1M8 5.5h1"/><path d="m11 15 3 3 7-7" stroke-width="2.2"/>' : web ? '<circle cx="12" cy="12" r="9"/><ellipse cx="12" cy="12" rx="4" ry="9"/><path d="M3 12h18M5 6.5h14M5 17.5h14"/>' : '<rect x="7" y="7" width="14" height="14" rx="2"/><path d="M16 7V3H3v13h4"/>') + '</g></svg>')
}
