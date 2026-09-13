import QtQuick
import QtQuick.Window
import ".."
Window {
    visible: true; width: 120; height: 40
    Row {
        ResourceIcon { id: app; width: 40; height: 40; ink: "#428866"; installed: true }
        ResourceIcon { id: browser; width: 40; height: 40; ink: "#428866" }
        ResourceIcon { id: host; width: 40; height: 40; ink: "#428866"; web: false }
    }
    Timer {
        interval: 300; running: true
        onTriggered: {
            if ([app,browser,host].some(icon => icon.status !== Image.Ready) || app.source === browser.source || browser.source === host.source) { console.error("Resource SVG variants failed"); Qt.exit(1); return }
            app.installed = false
            app.ink = "#7755aa"
            verify.start()
        }
    }
    Timer {
        id: verify; interval: 300
        onTriggered: {
            if (app.status !== Image.Ready || app.source.toString().indexOf("7755aa") < 0 || app.source.toString().indexOf("ellipse") < 0) { console.error("Resource icon update failed"); Qt.exit(1); return }
            Qt.quit()
        }
    }
}
