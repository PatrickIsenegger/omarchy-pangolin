import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import qs.Ui as Ui

Ui.Panel {
  id: root
  moduleName: "patrick.pangolin"
  manageIpc: false
  readonly property bool demo: setting("demo", false)
  readonly property string helper: Qt.resolvedUrl("backend.py").toString().replace(/^file:\/\//, "")
  property var status: ({state: "unknown", label: "Checking status", running: null})
  property var items: []
  property string resourceError: ""
  property string actionError: ""
  property bool stale: true
  property double lastUpdate: 0
  property bool launching: false
  property string installing: ""
  ThemePalette { id: themePalette }
  readonly property color dotColor: stale || launching || status.state === "unknown" || status.state === "pending" || status.state === "warning" ? themePalette.warning : status.state === "connected" ? themePalette.success : themePalette.error
  readonly property bool busy: launching || operation.running
  readonly property bool healthy: !stale && status.state === "connected"
  readonly property bool loading: resourcePoll.running
  readonly property color statusColor: dotColor
  readonly property string title: stale ? "Status unavailable" : launching ? "Connecting…" : status.label
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function command(action) {
    let args = ["/usr/bin/python3", helper]
    if (demo) args.push("--demo")
    args.push(action)
    return args
  }
  function refresh() { if (!poll.running) poll.running = true }
  function loadResources() { if (!resourcePoll.running) resourcePoll.running = true }
  function connectClient() {
    if (demo || busy || stale || status.running !== false) return
    launching = true; launchGuard.restart()
    Quickshell.execDetached(["omarchy", "launch", "terminal"].concat(command("connect")))
  }
  function run(action, id) {
    if (demo || busy) return
    actionError = ""
    if (action === "install") installing = id
    let args = ["/usr/bin/timeout", "45"].concat(command(action))
    if (id) args.push(id)
    operation.command = args
    operation.running = true
  }
  function openResource(item) {
    if (demo) return
    if (item.url && item.enabled) run("open", item.id)
    else copyResource(item)
  }
  function copyResource(item) { if (!demo) Quickshell.execDetached(["wl-copy", "--", item.url || item.address]) }
  function openHelp() { if (!demo) Quickshell.execDetached(["xdg-open", "https://github.com/PatrickIsenegger/omarchy-pangolin/blob/main/docs/README.md"]) }
  function restartApp() { if (!demo) { close(); Quickshell.execDetached(["omarchy", "restart", "shell"]) } }
  onOpenedChanged: if (opened) { refresh(); loadResources() }
  onDemoChanged: { stale = true; items = []; refresh(); loadResources() }
  Component.onCompleted: refresh()
  Timer { id: launchGuard; interval: 60000; onTriggered: { root.launching = false; root.refresh() } }
  Timer {
    interval: root.opened || root.busy ? 3000 : 15000; running: true; repeat: true
    onTriggered: { if (Date.now() - root.lastUpdate > 22000) root.stale = true; root.refresh() }
  }
  Process {
    id: poll
    command: ["/usr/bin/timeout", "6"].concat(root.command("status"))
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          root.status = JSON.parse(text); root.stale = !root.status.state
          root.lastUpdate = Date.now()
          if (root.status.running === true) { root.launching = false; launchGuard.stop() }
          if (root.healthy && root.opened) content.sample()
        } catch (e) { root.stale = true }
      }
    }
    onExited: function(code) { if (code !== 0) root.stale = true }
  }
  Process {
    id: resourcePoll
    command: ["/usr/bin/timeout", "15"].concat(root.command("resources"))
    onStarted: { root.items = []; root.resourceError = "" }
    stdout: StdioCollector {
      onStreamFinished: {
        try { const data = JSON.parse(text); root.items = data.items; root.resourceError = data.error || "" }
        catch (e) { root.resourceError = "Resource list unavailable." }
      }
    }
    onExited: function(code) { if (code !== 0 && !root.resourceError) root.resourceError = "Resource request failed or timed out." }
  }
  Process {
    id: operation
    stdout: StdioCollector {
      onStreamFinished: { try { root.actionError = JSON.parse(text).error || "" } catch(e) {} }
    }
    onExited: function(code) {
      if (code !== 0 && !root.actionError) root.actionError = "Action failed or timed out. Check dependencies and connection."
      root.installing = ""; root.refresh(); root.loadResources()
    }
  }
  BarIconButton {
    id: button
    anchors.fill: parent; bar: root.bar; text: "◇"; foreground: Color.accent; interactive: true
    iconComponent: Item {
      Mark { anchors.fill: parent; ink: Color.accent; connected: root.healthy && root.opened; ambient: true }
      Rectangle {
        anchors.right: parent.right; anchors.bottom: parent.bottom
        width: Math.max(6, Style.space(6)); height: width; radius: width / 2
        color: root.dotColor
        border.width: 1
        border.color: Color.bar.background
      }
    }
    tooltipText: root.opened ? "" : "Pangolin · " + root.title
    onPressed: function(b) { if (b === Qt.RightButton) root.run("dashboard"); else root.toggle() }
  }
  KeyboardPanel {
    id: popup
    anchorItem: button; owner: root; bar: root.bar; open: root.opened; focusTarget: content
    contentWidth: popup.fittedContentWidth(Style.space(350))
    contentHeight: popup.fittedContentHeight(content.implicitHeight)
    Dashboard { id: content; width: parent.width; height: parent.height; control: root }
  }
}
