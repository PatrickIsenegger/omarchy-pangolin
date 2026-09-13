import QtQuick
import QtQuick.Window
import qs.Commons
import ".."

Window {
  id: window
  width: 430; height: 620; visible: true
  color: Color.background
  property string target: Qt.resolvedUrl("../assets/demo-" + (light ? "light" : "dark") + ".png").toString().replace(/^file:\/\//, "")
  property bool light: false
  QtObject {
    id: demo
    property bool demo: true
    property bool healthy: true
    property bool opened: true
    property bool stale: false
    property bool busy: false
    property bool loading: false
    property string installing: ""
    property string title: "Connected · demo"
    property color dotColor: window.light ? "#4b7959" : "#94af87"
    property color statusColor: dotColor
    property string resourceError: ""
    property string actionError: ""
    property var status: ({state:"connected",running:true,peerCount:1,peerTotal:1,tunnelIp:"192.0.2.10",dns:"192.0.2.1",detail:"Synthetic preview"})
    property var items: [
      {id:"public:1",name:"Documents",url:"https://files.example.com",address:"",internal:false,enabled:true,appInstalled:true,site:"Demo Site"},
      {id:"public:2",name:"Dashboard",url:"https://dashboard.example.com",address:"",internal:false,enabled:true,appInstalled:false,site:"Demo Site"},
      {id:"public:3",name:"Notes",url:"https://notes.example.com",address:"",internal:false,enabled:true,appInstalled:false,site:"Demo Site"},
      {id:"public:4",name:"Photos",url:"https://photos.example.com",address:"",internal:false,enabled:true,appInstalled:false,site:"Demo Site"},
      {id:"site:1",name:"Wiki",url:"http://wiki.internal:8080",address:"",internal:true,enabled:true,appInstalled:true,site:"Demo Site"},
      {id:"site:2",name:"Metrics",url:"http://metrics.internal:3000",address:"",internal:true,enabled:true,appInstalled:false,site:"Demo Site"}
    ]
    function close() {}
    function loadResources() {}
  }
  Rectangle {
    id: shot
    anchors.fill: parent
    color: Color.background
    Text { x: 28; y: 24; text: "PANGOLIN / OMARCHY"; color: Color.accent; font.pixelSize: 16; font.bold: true; font.family: "sans-serif" }
    Text { x: 28; y: 49; text: window.light ? "Light theme · synthetic demo" : "Dark theme · synthetic demo"; color: Color.foreground; font.pixelSize: 12; font.family: "sans-serif" }
    Rectangle {
      x: 24; y: 82; width: 382; height: dashboard.implicitHeight + 24
      radius: 16; color: Color.popups.background
      border.color: Color.popups.border
      Dashboard { id: dashboard; x:12; y:12; width:358; height:implicitHeight; control: demo }
    }
  }
  Timer {
    interval: 400; running: true
    onTriggered: {
      Color.foreground = window.light ? "#283342" : "#d6e1e7"
      Color.background = window.light ? "#f4f2ed" : "#15212a"
      Color.accent = window.light ? "#395bb5" : "#8bceb9"
      Color.urgent = window.light ? "#a82b39" : "#f19091"
      Color.shellValues = ({})
      capture.start()
    }
  }
  Timer { id: capture; interval: 400; onTriggered: shot.grabToImage(function(result) { result.saveToFile(window.target); Qt.quit() }) }
}
