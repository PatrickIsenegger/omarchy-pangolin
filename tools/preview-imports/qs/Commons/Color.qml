pragma Singleton
import QtQuick
// Synthetic adapter for offline rendering only; production uses Omarchy.
QtObject {
  property color foreground: "#d6e1e7"
  property color background: "#15212a"
  property color accent: "#8bceb9"
  property color urgent: "#f19091"
  property var shellValues: ({})
  readonly property QtObject popups: QtObject {
    property color text: foreground
    property color background: Qt.rgba(foreground.r,foreground.g,foreground.b,0.045)
    property color border: Qt.rgba(foreground.r,foreground.g,foreground.b,0.16)
  }
}
