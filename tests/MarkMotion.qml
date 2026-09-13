import QtQuick
import QtQuick.Window
import ".."

Window {
  visible: true; width: 100; height: 100
  Mark { id: mark; anchors.fill: parent; ink: "#428866"; connected: true; ambient: true }
  Timer {
    interval: 3000; running: true
    onTriggered: {
      if (mark.children[0].status !== Image.Ready || mark.pulse <= 1) { console.error("SVG or connected motion failed"); Qt.exit(1); return }
      mark.connected = false
      if (mark.pulse !== 1 || mark.tilt !== 0) { console.error("Disconnect did not reset motion"); Qt.exit(1); return }
      mark.ink = "#7755aa"
      verify.start()
    }
  }
  Timer {
    id: verify; interval: 500
    onTriggered: {
      if (mark.pulse !== 1 || mark.tilt !== 0 || mark.children[0].source.toString().indexOf("7755aa") < 0) { console.error("Disconnected or recolor state failed"); Qt.exit(1); return }
      console.log("SVG load, connected animation, immediate stop and theme recoloring passed")
      Qt.quit()
    }
  }
}
