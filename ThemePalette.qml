import QtQuick
import Quickshell.Io
import qs.Commons

// Semantic colors not exported by Color.qml, read from the active theme.
QtObject {
  id: palette
  property var tones: ({})
  readonly property color success: tones.green || tones.color2 || Color.accent
  readonly property color warning: tones.yellow || tones.color3 || Color.foreground
  readonly property color inactive: Color.muted
  function parse(raw) {
    const found = {}
    for (const line of String(raw).split("\n")) {
      const match = line.match(/^\s*(green|yellow|color2|color3)\s*=\s*["']?(#[0-9a-fA-F]{6})/)
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
  }
}
