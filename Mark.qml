import QtQuick

// Original SVG rendered once per theme color. Animation uses transforms only.
Item {
  id: mark
  property color ink
  property bool connected: false
  property bool ambient: false
  property real pulse: 1
  property real tilt: 0
  function settle() { breathing.stop(); heartbeat.stop(); pulse = 1; tilt = 0 }
  function updateMotion() {
    settle()
    if (connected && ambient) breathing.start()
  }
  onConnectedChanged: updateMotion()
  onAmbientChanged: updateMotion()
  Component.onCompleted: updateMotion()
  function sample() { if (connected && !ambient) heartbeat.restart() }
  Image {
    anchors.fill: parent
    sourceSize.width: 96; sourceSize.height: 96
    fillMode: Image.PreserveAspectFit
    source: "data:image/svg+xml;utf8," + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><g fill="none" stroke="' + mark.ink + '" stroke-width="4" stroke-linecap="round"><rect x="15" y="15" width="34" height="34" rx="10" transform="rotate(45 32 32)"/><path d="M19 36 L45 28"/></g><g fill="' + mark.ink + '"><circle cx="17" cy="36" r="7"/><circle cx="47" cy="28" r="7"/></g></svg>')
    scale: mark.pulse; rotation: mark.tilt
  }
  SequentialAnimation {
    id: breathing
    loops: Animation.Infinite
    PauseAnimation { duration: 2400 }
    ParallelAnimation {
      NumberAnimation { target: mark; property: "pulse"; to: 1.06; duration: 450; easing.type: Easing.InOutSine }
      NumberAnimation { target: mark; property: "tilt"; to: -3; duration: 450; easing.type: Easing.InOutSine }
    }
    ParallelAnimation {
      NumberAnimation { target: mark; property: "pulse"; to: 1; duration: 650; easing.type: Easing.InOutSine }
      NumberAnimation { target: mark; property: "tilt"; to: 0; duration: 650; easing.type: Easing.InOutSine }
    }
  }
  SequentialAnimation {
    id: heartbeat
    NumberAnimation { target: mark; property: "pulse"; from: 1; to: 1.06; duration: 160 }
    NumberAnimation { target: mark; property: "pulse"; to: 1; duration: 260 }
  }
}
