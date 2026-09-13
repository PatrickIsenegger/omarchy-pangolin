pragma Singleton
import QtQuick
QtObject {
  function space(value) { return value }
  readonly property QtObject font: QtObject {
    property string family: "monospace"
    property int caption: 12
    property int body: 14
  }
}
