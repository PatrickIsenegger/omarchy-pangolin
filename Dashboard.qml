import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons

FocusScope {
  id: view
  required property var control
  readonly property color ink: Color.popups.text
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
  function sample() { mark.sample() }
  Flickable {
    anchors.fill: parent; contentHeight: content.implicitHeight; clip: true
    boundsBehavior: Flickable.StopAtBounds
    Column {
      id: content
      width: parent.width; spacing: Style.space(10)
      Rectangle {
        width: parent.width; height: Style.space(64); radius: Style.space(12)
        color: Qt.rgba(view.accent.r, view.accent.g, view.accent.b, 0.10)
        border.color: Qt.rgba(view.accent.r, view.accent.g, view.accent.b, 0.22)
        RowLayout {
          anchors.fill: parent; anchors.margins: Style.space(10); spacing: Style.space(10)
          Mark { id: mark; Layout.preferredWidth: Style.space(34); Layout.preferredHeight: Style.space(34); ink: control.statusColor; connected: control.healthy && control.opened }
          Column {
            Layout.fillWidth: true; Layout.minimumWidth: 0; spacing: 4
            Label { text: "Pangolin"; font.bold: true; font.pixelSize: Style.font.body + 2 }
            Label { width: parent.width; text: (control.healthy ? "●  " : "◇  ") + control.title; color: control.statusColor; elide: Text.ElideRight }
          }
          Action { text: "×"; Accessible.name: "Close panel"; onClicked: control.close() }
        }
      }
      RowLayout {
        width: parent.width
        Label { Layout.fillWidth: true; text: "PUBLIC RESOURCES"; color: view.muted }
        Action { visible: view.externalItems.length > 6; text: view.all ? "Less" : "All " + view.externalItems.length; onClicked: view.all = !view.all }
      }
      ResourceGrid { resources: view.all ? view.externalItems : view.externalItems.slice(0, 6); compact: false }
      RowLayout {
        width: parent.width
        Label { Layout.fillWidth: true; text: "PRIVATE RESOURCES"; color: view.internalAccent }
        Action { text: "↻"; Accessible.name: "Refresh resources"; enabled: !control.loading; onClicked: control.loadResources() }
      }
      ResourceGrid { resources: view.internalItems; compact: true }
      Label { width: parent.width; visible: control.loading || !!control.resourceError || !control.items.length; text: control.loading ? "Loading resources…" : control.resourceError || "No resources available."; wrapMode: Text.WordWrap }
      Label { width: parent.width; visible: view.internalItems.length > 0; text: "Private apps use your Pangolin connection and alias DNS."; wrapMode: Text.WordWrap; color: view.muted }
      RowLayout {
        width: parent.width; spacing: Style.space(6)
        Action { Layout.fillWidth: true; text: "Connect"; primary: true; enabled: !control.demo && !control.busy && !control.stale && control.status.running === false; onClicked: control.connectClient() }
        Action { Layout.fillWidth: true; text: "Disconnect"; enabled: !control.demo && !control.busy && !control.stale && control.status.running === true; onClicked: control.run("disconnect") }
      }
      RowLayout {
        width: parent.width; spacing: Style.space(6)
        Action { Layout.fillWidth: true; text: view.details ? "Details ▴" : "Details ▾"; onClicked: view.details = !view.details }
        Action { text: "Restart shell"; enabled: !control.demo; ToolTip.visible: hovered; ToolTip.text: "Restarts the entire Omarchy shell. The VPN stays connected."; onClicked: control.restartApp() }
        Action { text: "⚙"; Accessible.name: "Edit settings"; enabled: !control.demo && !control.busy; onClicked: control.run("settings") }
      }
      Column {
        width: parent.width; visible: view.details; spacing: Style.space(6)
        Label { width: parent.width; text: "Tunnel: " + (control.status.tunnelIp || "—") + "  ·  Sites: " + (control.status.peerCount || 0) + "/" + (control.status.peerTotal || 0); wrapMode: Text.WordWrap }
        Label { width: parent.width; text: "DNS: " + (control.status.dns || "—"); wrapMode: Text.WordWrap }
        Label { width: parent.width; text: control.status.detail || ""; wrapMode: Text.WordWrap; color: view.muted }
        RowLayout {
          width: parent.width
          Action { Layout.fillWidth: true; text: "Diagnose HTTPS"; enabled: !control.demo && !control.busy; onClicked: control.run("diagnose") }
          Action { Layout.fillWidth: true; text: "Dashboard ↗"; enabled: !control.demo && !control.busy; onClicked: control.run("dashboard") }
        }
      }
      Label { width: parent.width; visible: !!control.actionError; text: control.actionError; wrapMode: Text.WordWrap; color: Color.urgent }
      Label { width: parent.width; text: "Community plugin · 0.1.0-beta.2" + (control.demo ? " · DEMO" : ""); color: view.muted; horizontalAlignment: Text.AlignHCenter; font.pixelSize: Style.font.caption - 1 }
    }
  }
  component ResourceGrid: Grid {
    required property var resources
    property bool compact: false
    id: grid
    width: parent.width; columns: 2; spacing: Style.space(5)
    Repeater {
      model: grid.resources
      RowLayout {
        id: tile
        required property var modelData
        readonly property color tint: grid.compact ? view.internalAccent : view.accent
        property bool copied: false
        width: (grid.width - grid.spacing) / 2; height: Style.space(grid.compact ? 40 : 48); spacing: Style.space(2)
        Action {
          Layout.fillWidth: true; Layout.minimumWidth: 0; Layout.preferredWidth: 1
          implicitHeight: tile.height; tint: tile.tint; primary: grid.compact
          leftPadding: Style.space(6); rightPadding: Style.space(4)
          enabled: !control.demo && !control.busy && (tile.modelData.url ? tile.modelData.enabled : !!tile.modelData.address)
          Accessible.name: tile.modelData.name + (tile.modelData.url ? " open" : " copy address")
          ToolTip.visible: hovered
          ToolTip.text: tile.modelData.name + "\n" + (tile.modelData.url || tile.modelData.address) + "\n" + tile.modelData.site
          contentItem: RowLayout {
            spacing: Style.space(5)
            Label { text: grid.compact ? "◇" : "↗"; color: tile.tint; font.pixelSize: Style.font.body }
            Column {
              Layout.fillWidth: true; Layout.minimumWidth: 0; spacing: 2
              Label { width: parent.width; text: tile.modelData.name; font.bold: true; font.pixelSize: Style.font.caption - (grid.compact ? 1 : 0); elide: Text.ElideRight }
              Label { width: parent.width; text: !tile.modelData.enabled ? "Disabled" : tile.modelData.appInstalled ? "App ↗" : tile.modelData.url ? "Web ↗" : "Copy address"; color: tile.tint; font.pixelSize: Style.font.caption - 2; elide: Text.ElideRight }
            }
          }
          onClicked: control.openResource(tile.modelData)
        }
        Action {
          Layout.preferredWidth: Style.space(20); leftPadding: 0; rightPadding: 0
          text: tile.copied ? "✓" : "⧉"; enabled: !control.demo
          Accessible.name: "Copy " + tile.modelData.name
          ToolTip.visible: hovered; ToolTip.text: tile.copied ? "Copied" : "Copy URL or address"
          onClicked: { control.copyResource(tile.modelData); tile.copied = true; copiedTimer.restart() }
        }
        Action {
          visible: !!tile.modelData.url && !tile.modelData.appInstalled
          Layout.preferredWidth: Style.space(22); leftPadding: 0; rightPadding: 0
          text: control.installing === tile.modelData.id ? "…" : "+"; primary: true; tint: tile.tint
          enabled: !control.demo && !control.busy && tile.modelData.enabled
          Accessible.name: "Install " + tile.modelData.name + " as an app"
          ToolTip.visible: hovered; ToolTip.text: "Install as a web app"
          onClicked: control.run("install", tile.modelData.id)
        }
        Timer { id: copiedTimer; interval: 1500; onTriggered: tile.copied = false }
      }
    }
  }
  component Label: Text {
    color: view.ink; textFormat: Text.PlainText; font.family: view.family; font.pixelSize: Style.font.caption
  }
  component Action: Button {
    id: action
    property bool primary: false
    property color tint: view.accent
    implicitHeight: Style.space(28)
    implicitWidth: (contentItem ? contentItem.implicitWidth : 0) + Style.space(16)
    activeFocusOnTab: true; hoverEnabled: true
    opacity: enabled || control.demo ? 1 : 0.48
    background: Rectangle {
      radius: Style.space(7)
      color: action.primary ? Qt.rgba(action.tint.r,action.tint.g,action.tint.b,action.hovered ? 0.22 : 0.11) : Qt.rgba(view.ink.r,view.ink.g,view.ink.b,action.hovered ? 0.1 : 0.04)
      border.width: action.activeFocus ? 2 : 1
      border.color: action.activeFocus ? action.tint : Qt.rgba(action.tint.r,action.tint.g,action.tint.b,0.20)
    }
    contentItem: Label { text: action.text; color: action.primary ? action.tint : view.ink; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
  }
}
