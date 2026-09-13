import QtQuick

// Layered, original SVG washes. Theme colors only; no raster texture or shader.
Item {
  id: wash
  property color pigment
  property color shade: pigment
  property bool moving: false
  property real drift: 0
  onMovingChanged: { motion.stop(); drift = 0; if (moving) motion.start() }
  Component.onCompleted: if (moving) motion.start()
  Image {
    anchors.fill: parent
    sourceSize.width: 640; sourceSize.height: 240
    fillMode: Image.Stretch
    source: "data:image/svg+xml;utf8," + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 150"><path fill="' + wash.pigment + '" opacity=".07" d="M4 70C-4 20 51 1 93 19S153 2 201 24S265 5 313 32S410 56 397 102S331 131 286 139S199 124 151 140S55 131 23 111Z"/><path fill="' + wash.pigment + '" opacity=".07" d="M20 63C37 9 96 35 127 29S191 43 224 28S306 26 350 47S375 110 334 116S254 136 212 115S151 135 106 118S7 103 20 63Z"/><path fill="' + wash.shade + '" opacity=".04" d="M153 41C197 13 253 55 288 39S358 42 376 76S340 127 301 120S225 140 192 116S124 75 153 41Z"/><path fill="none" stroke="' + wash.pigment + '" stroke-width=".6" opacity=".18" d="M20 108C89 123 94 99 166 118S282 131 375 99"/><g fill="' + wash.pigment + '" opacity=".18"><circle cx="31" cy="31" r="2"/><circle cx="366" cy="25" r="1.5"/><circle cx="388" cy="118" r="2"/><circle cx="87" cy="135" r="1"/></g></svg>')
    rotation: wash.drift * 0.7
    scale: 1 + wash.drift * 0.014
    transform: Translate { x: wash.drift * 2 }
  }
  SequentialAnimation {
    id: motion; loops: Animation.Infinite
    NumberAnimation { target: wash; property: "drift"; from: 0; to: 1; duration: 3500; easing.type: Easing.InOutSine }
    NumberAnimation { target: wash; property: "drift"; to: -1; duration: 6500; easing.type: Easing.InOutSine }
    NumberAnimation { target: wash; property: "drift"; to: 0; duration: 3500; easing.type: Easing.InOutSine }
    PauseAnimation { duration: 1500 }
  }
}
