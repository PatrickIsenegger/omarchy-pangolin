import QtQuick
import Quickshell.Io
import qs.Commons

// Semantic colors not exported by Color.qml, read from the active theme.
QtObject {
  id: palette
  property var tones: ({})
  readonly property color accent: Color.accent
  readonly property color namedGreen: tones.green || tones.color2 || "transparent"
  readonly property color namedOrange: tones.orange || "transparent"
  readonly property color namedYellow: tones.yellow || tones.color3 || "transparent"
  readonly property color namedRed: tones.red || tones.color1 || "transparent"
  readonly property color success: semantic(namedGreen, 0.36, 0.20, 0.46)
  readonly property color warning: semantic(namedOrange.a > 0 ? namedOrange : namedYellow, 0.08, 0.03, 0.12)
  readonly property color error: semantic(namedRed, 0.00, 0.94, 0.08)
  readonly property color inactive: Color.muted
  function derived(hue) {
    const saturation = Math.max(0.46, Math.min(0.88, Number(palette.accent.hslSaturation) || 0.66))
    const lightness = Math.max(0.34, Math.min(0.68, Number(palette.accent.hslLightness) || 0.52))
    return Qt.hsla(hue, saturation, lightness, 1)
  }
  function semantic(candidate, hue, minimum, maximum) {
    const actual = Number(candidate.hslHue)
    if (candidate.a > 0 && isFinite(actual) && (minimum <= maximum ? actual >= minimum && actual <= maximum : actual >= minimum || actual <= maximum)) return candidate
    return derived(hue)
  }
  function parse(raw) {
    const found = {}
    for (const line of String(raw).split("\n")) {
      const match = line.match(/^\s*(red|orange|yellow|green|color1|color2|color3)\s*=\s*["']?(#[0-9a-fA-F]{3}(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{5})?)\b/)
      if (match) found[match[1]] = match[2]
    }
    tones = found
  }
  property FileView source: FileView {
    path: Color.currentThemePath + "/colors.toml"
    watchChanges: true; printErrors: false
    onLoaded: palette.parse(text())
    onLoadFailed: palette.tones = ({})
    onFileChanged: reload()
  }
  property Connections themeChanges: Connections {
    target: Color
    function onShellValuesChanged() { palette.source.reload() }
    function onCurrentThemePathChanged() { palette.source.reload() }
  }
}
