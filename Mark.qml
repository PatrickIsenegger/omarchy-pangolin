import QtQuick

// Original geometric network mark: no third-party logo artwork.
Item {
  id: mark
  property color ink
  property bool connected: false
  property real pulse: 1
  onConnectedChanged: if (!connected) { animation.stop(); pulse = 1 }
  scale: pulse
  function sample() { if (connected) animation.restart() }
  Rectangle {
    anchors.centerIn: parent
    width: parent.width * 0.66; height: width
    radius: width * 0.27; rotation: 45
    color: "transparent"; border.color: mark.ink; border.width: 2
  }
  Rectangle { x: parent.width * 0.15; y: parent.height * 0.43; width: parent.width * 0.24; height: width; radius: width / 2; color: mark.ink }
  Rectangle { x: parent.width * 0.61; y: parent.height * 0.33; width: parent.width * 0.24; height: width; radius: width / 2; color: mark.ink }
  SequentialAnimation {
    id: animation
    NumberAnimation { target: mark; property: "pulse"; from: 1; to: 1.06; duration: 160 }
    NumberAnimation { target: mark; property: "pulse"; to: 1; duration: 260 }
  }
}
