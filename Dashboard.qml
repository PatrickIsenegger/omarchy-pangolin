import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import "Version.js" as Version

FocusScope {
  id: view
  required property var control
  readonly property color ink: Color.popups.text
  readonly property color tooltipSurface: Qt.tint(Color.background, Color.popups.background)
  readonly property color muted: Qt.rgba(ink.r, ink.g, ink.b, 0.68)
  readonly property color accent: Color.accent
  readonly property color internalAccent: Qt.tint(ink, Qt.rgba(accent.r, accent.g, accent.b, 0.42))
  readonly property string family: Style.font.family
  property bool details: false
  property bool all: false
  readonly property var externalItems: control.items.filter(r => !r.internal)
  readonly property var internalItems: control.items.filter(r => r.internal)
  implicitHeight: content.implicitHeight
  Keys.onEscapePressed: control.close()
  readonly property string statusHint: control.stale ? "Status could not be confirmed. Reopen the panel to retry; no connection animation runs." : control.healthy ? "Pangolin is connected. Private resources also require working alias DNS. Individual sites may connect on demand." : control.status.state === "warning" ? "Pangolin needs attention. Open Details for the reported condition." : control.status.state === "off" ? "Pangolin is disconnected. Connect to access private resources." : control.status.state === "error" ? "Pangolin reported an error. Open Details or run Diagnose HTTPS." : "Connection is not yet confirmed. Open Details for more information."
  function resourceHint(item) {
    const action = !item.enabled ? "This resource is disabled." : !item.url ? "Click to copy the host address. No web protocol is configured." : item.appInstalled ? "Installed app · click to open its app window." : "Browser link · click to open in your browser. Use the actions menu to install as an app."
    return item.name + "\n" + action + "\n" + (item.url || item.address || "") + (item.site ? "\nSite: " + item.site : "") + (item.internal ? "\nRequires a Pangolin connection and alias DNS." : "")
  }
  function sample() { mark.sample() }
  Flickable {
    anchors.fill: parent; contentHeight: content.implicitHeight; clip: true
    boundsBehavior: Flickable.StopAtBounds
    Column {
      id: content
      width: parent.width; spacing: Style.space(10)
      Rectangle {
        width: parent.width; height: Style.space(100); radius: Style.space(12)
        color: Qt.rgba(view.ink.r, view.ink.g, view.ink.b, 0.025)
        border.color: Qt.rgba(view.accent.r, view.accent.g, view.accent.b, 0.3)
        clip: true
        Wash { anchors.fill: parent; anchors.margins: -Style.space(12); pigment: view.accent; shade: view.accent; moving: control.healthy && control.opened }
        HoverHandler { id: statusHover }
        ToolTip { visible: statusHover.hovered; delay: 550; padding: Style.space(8); text: view.statusHint; contentItem: Label { text: view.statusHint; width: Style.space(290); wrapMode: Text.WordWrap } background: Rectangle { color: Qt.rgba(view.tooltipSurface.r, view.tooltipSurface.g, view.tooltipSurface.b, 1); radius: 8; border.color: view.accent } }
        RowLayout {
          anchors.fill: parent; anchors.margins: Style.space(12); spacing: Style.space(12)
          Item {
            Layout.preferredWidth: Style.space(56); Layout.preferredHeight: Style.space(64)
            Rectangle { anchors.centerIn: parent; width: Style.space(53); height: width; radius: width/2; color: "transparent"; border.color: Qt.rgba(view.accent.r, view.accent.g, view.accent.b, 0.22) }
            Mark { id: mark; anchors.centerIn: parent; width: Style.space(40); height: width; ink: view.accent; connected: control.healthy && control.opened; ambient: true }
            Rectangle { width: Style.space(6); height: width; radius: width/2; x: Style.space(43); y: Style.space(7); color: control.dotColor; border.width: 1; border.color: Color.popups.background }
          }
          Column {
            Layout.fillWidth: true; Layout.minimumWidth: 0; spacing: 3
            Label { text: "YOUR CONNECTIONS"; color: view.muted; font.pixelSize: Style.font.caption - 3; font.letterSpacing: 1.4 }
            Label { text: "Pangolin"; color: view.accent; font.family: "serif"; font.pixelSize: Style.font.body + 12 }
            Label { width: parent.width; text: control.title; color: view.ink; elide: Text.ElideRight }
          }
          Action { text: "×"; Accessible.name: "Close panel"; hint: "Close panel · Esc"; onClicked: control.close() }
        }
      }
      RowLayout {
        width: parent.width
        Label { Layout.fillWidth: true; text: "Public resources  ·  " + view.externalItems.length; color: view.muted }
        Action { visible: view.externalItems.length > 8; text: view.all ? "Less" : "All " + view.externalItems.length; hint: view.all ? "Show the first eight public resources" : "Show all public resources"; onClicked: view.all = !view.all }
      }
      ResourceGrid { resources: view.all ? view.externalItems : view.externalItems.slice(0, 8); compact: false }
      RowLayout {
        width: parent.width
        Label { Layout.fillWidth: true; text: "Private resources  ·  " + view.internalItems.length; color: view.internalAccent }
        Action { text: "↻"; Accessible.name: "Refresh resources"; hint: "Reload resources and check which web apps are installed"; enabled: !control.loading; onClicked: control.loadResources() }
      }
      ResourceGrid { resources: view.internalItems; compact: true }
      Label { width: parent.width; visible: control.loading || !!control.resourceError || !control.items.length; text: control.loading ? "Loading resources…" : control.resourceError || "No resources available."; wrapMode: Text.WordWrap }
      Label { width: parent.width; visible: view.internalItems.length > 0; text: "Private apps use your Pangolin connection and alias DNS."; wrapMode: Text.WordWrap; color: view.muted }
      RowLayout {
        width: parent.width; spacing: Style.space(6)
        Action { Layout.fillWidth: true; text: "Connect"; hint: "Start Pangolin in a terminal. Complete any authentication or privilege prompt there."; primary: true; enabled: !control.demo && !control.busy && !control.stale && control.status.running === false; onClicked: control.connectClient() }
        Action { Layout.fillWidth: true; text: "Disconnect"; hint: "Stop the Pangolin connection. Private services will no longer be reachable through it."; enabled: !control.demo && !control.busy && !control.stale && control.status.running === true; onClicked: control.run("disconnect") }
      }
      RowLayout {
        width: parent.width; spacing: Style.space(6)
        Action { Layout.fillWidth: true; text: view.details ? "Details ▴" : "Details ▾"; hint: "Tunnel address, DNS, site connections and diagnostics"; onClicked: view.details = !view.details }
        Action { text: "Restart shell"; enabled: !control.demo; hint: "Restarts the entire Omarchy shell, including other plugins. The VPN stays connected."; onClicked: control.restartApp() }
        Action { text: "⚙"; Accessible.name: "Edit settings"; hint: "Edit local settings: private web URLs and protocol overrides"; enabled: !control.demo && !control.busy; onClicked: control.run("settings") }
      }
      Column {
        width: parent.width; visible: view.details; spacing: Style.space(6)
        Label { width: parent.width; text: "Tunnel: " + (control.status.tunnelIp || "—") + "  ·  Sites: " + (control.status.peerCount || 0) + "/" + (control.status.peerTotal || 0); wrapMode: Text.WordWrap }
        Label { width: parent.width; text: "DNS: " + (control.status.dns || "—"); wrapMode: Text.WordWrap }
        Label { width: parent.width; text: control.status.detail || ""; wrapMode: Text.WordWrap; color: view.muted }
        RowLayout {
          width: parent.width
          Action { Layout.fillWidth: true; text: "Diagnose HTTPS"; hint: "Check HTTPS connectivity to your selected Pangolin server"; enabled: !control.demo && !control.busy; onClicked: control.run("diagnose") }
          Action { Layout.fillWidth: true; text: "Dashboard"; hint: "Open the dashboard of your active Pangolin account"; enabled: !control.demo && !control.busy; onClicked: control.run("dashboard") }
        }
      }
      Label { width: parent.width; visible: !!control.actionError; text: control.actionError; wrapMode: Text.WordWrap; color: Color.urgent }
      RowLayout {
        width: parent.width
        Label { Layout.fillWidth: true; text: "Community · " + Version.current + (control.demo ? " · DEMO" : ""); color: view.muted; font.pixelSize: Style.font.caption - 1 }
        Action { text: "? Help"; enabled: !control.demo; hint: "Open the user guide, icon legend and troubleshooting on GitHub"; onClicked: control.openHelp() }
      }
    }
  }
  component ResourceGrid: Grid {
    required property var resources
    property bool compact: false
    id: grid
    width: parent.width; columns: 2; spacing: Style.space(4)
    Repeater {
      model: grid.resources
      RowLayout {
        id: tile
        required property var modelData
        readonly property color tint: grid.compact ? view.internalAccent : view.accent
        width: (grid.width - grid.spacing) / 2; height: Style.space(grid.compact ? 30 : 34); spacing: 0
        Action {
          id: resourceButton
          Layout.fillWidth: true; Layout.minimumWidth: 0; Layout.preferredWidth: 1
          implicitHeight: tile.height; tint: tile.tint; tinted: !!tile.modelData.appInstalled
          leftPadding: Style.space(6); rightPadding: Style.space(4)
          enabled: !control.demo && !control.busy && (tile.modelData.url ? tile.modelData.enabled : !!tile.modelData.address)
          Accessible.name: tile.modelData.name + (tile.modelData.appInstalled ? " installed app" : tile.modelData.url ? " browser link" : " copy address")
          hint: view.resourceHint(tile.modelData)
          contentItem: RowLayout {
            spacing: Style.space(6)
            Item {
              id: resourceIconFrame
              Layout.preferredWidth: Style.space(18); Layout.preferredHeight: Style.space(18)
              ResourceIcon { anchors.fill: parent; ink: tile.tint; installed: !!tile.modelData.appInstalled; web: !!tile.modelData.url }
              Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
              scale: resourceButton.hovered ? 1.08 : 1
            }
            Label { Layout.fillWidth: true; Layout.minimumWidth: 0; text: tile.modelData.name; font.pixelSize: Style.font.caption - (grid.compact ? 1 : 0); elide: Text.ElideRight }
          }
          onClicked: control.openResource(tile.modelData)
          TapHandler { acceptedButtons: Qt.RightButton; onTapped: resourceMenu.open() }
        }
        Action {
          Layout.preferredWidth: Style.space(20); implicitHeight: tile.height; leftPadding: 0; rightPadding: 0
          text: control.installing === tile.modelData.id ? "…" : "⋮"
          Accessible.name: "Actions for " + tile.modelData.name
          hint: "Copy address" + (tile.modelData.url && !tile.modelData.appInstalled ? " or install as an app" : "") + " · also available with right-click"
          onClicked: resourceMenu.open()
        }
        Popup {
          id: resourceMenu
          parent: Overlay.overlay
          onAboutToShow: {
            if (!Overlay.overlay) { close(); return }
            const point = tile.mapToItem(Overlay.overlay, 0, tile.height)
            x = Math.max(Style.space(6), Math.min(point.x, Overlay.overlay.width - width - Style.space(6)))
            y = Math.max(Style.space(6), Math.min(point.y, Overlay.overlay.height - height - Style.space(6)))
          }
          width: Style.space(240); padding: Style.space(6); focus: true
          background: Rectangle { color: view.tooltipSurface; radius: Style.space(9); border.color: tile.tint }
          contentItem: Column {
            spacing: Style.space(4)
            Label { width: parent.width; text: tile.modelData.name; elide: Text.ElideRight; font.bold: true; padding: Style.space(4) }
            Action {
              width: parent.width; text: tile.modelData.appInstalled ? "Open app" : tile.modelData.url ? "Open in browser" : "Copy host address"
              enabled: !control.demo && !control.busy && (tile.modelData.url ? tile.modelData.enabled : !!tile.modelData.address)
              onClicked: { resourceMenu.close(); control.openResource(tile.modelData) }
            }
            Action {
              width: parent.width; visible: !!tile.modelData.url; text: "Copy URL"; enabled: !control.demo
              onClicked: { control.copyResource(tile.modelData); resourceMenu.close() }
            }
            Action {
              width: parent.width; visible: !!tile.modelData.url && !tile.modelData.appInstalled; text: "Install as app"
              enabled: !control.demo && !control.busy && tile.modelData.enabled
              hint: "Adds an Omarchy app launcher. The service remains on its server."
              onClicked: { resourceMenu.close(); control.run("install", tile.modelData.id) }
            }
          }
        }
      }
    }
  }
  component Label: Text {
    color: view.ink; textFormat: Text.PlainText; font.family: view.family; font.pixelSize: Style.font.caption
  }
  component Action: Button {
    id: action
    property bool primary: false
    property bool emphasized: false
    property bool tinted: false
    property string hint: ""
    Accessible.description: hint
    HoverHandler { id: actionHover }
    ToolTip {
      visible: (actionHover.hovered || action.activeFocus) && !!action.hint; delay: 550; padding: Style.space(8)
      contentItem: Label { text: action.hint; width: Math.min(implicitWidth, Style.space(290)); wrapMode: Text.Wrap }
      background: Rectangle { color: Qt.rgba(view.tooltipSurface.r, view.tooltipSurface.g, view.tooltipSurface.b, 1); radius: Style.space(8); border.color: action.tint }
    }
    property color tint: view.accent
    implicitHeight: Style.space(28)
    implicitWidth: (contentItem ? contentItem.implicitWidth : 0) + Style.space(16)
    activeFocusOnTab: true; hoverEnabled: true
    opacity: enabled || control.demo ? 1 : 0.48
    background: Rectangle {
      radius: Style.space(9)
      clip: true
      color: action.tinted ? Qt.rgba(action.tint.r,action.tint.g,action.tint.b,action.hovered ? 0.16 : 0.085) : Qt.rgba(view.ink.r,view.ink.g,view.ink.b,action.hovered ? 0.065 : 0.025)
      border.width: action.activeFocus || action.emphasized ? 2 : 1
      border.color: action.activeFocus ? action.tint : action.emphasized ? Qt.rgba(action.tint.r,action.tint.g,action.tint.b,0.48) : Qt.rgba(action.tint.r,action.tint.g,action.tint.b,0.16)
      Wash {
        anchors.fill: parent; anchors.margins: -4
        visible: action.primary
        pigment: action.tint; shade: view.ink
        opacity: action.hovered ? 0.95 : 0.62
      }
    }
    contentItem: Label { text: action.text; color: action.primary ? action.tint : view.ink; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
  }
}
