import QtQuick
import QtQuick.Window
import ".."

Window {
    visible: true; width: 400; height: 150
    Wash { id: wash; anchors.fill: parent; pigment: "#428866"; moving: true }
    Timer {
        interval: 600; running: true
        onTriggered: {
            if (wash.children[0].status !== Image.Ready || wash.drift <= 0) { console.error("Wash SVG or motion failed"); Qt.exit(1); return }
            wash.moving = false
            if (wash.drift !== 0) { console.error("Wash did not reset"); Qt.exit(1); return }
            wash.pigment = "#7755aa"
            verify.start()
        }
    }
    Timer {
        id: verify; interval: 400
        onTriggered: {
            if (wash.drift !== 0 || wash.children[0].source.toString().indexOf("7755aa") < 0) { console.error("Wash offline or theme state failed"); Qt.exit(1); return }
            Qt.quit()
        }
    }
}
