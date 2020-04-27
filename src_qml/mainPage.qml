import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

//CUTOM_IMPORT____________________________
import usr.serversList 1.0
//________________________________________

Page {
    id: welcomePage
    title: "welcomePage"
    property string _name: ""
    header: MenuBar {
        id: menuBar
        Menu {
            title: qsTr("&File")
            Action { text: qsTr("&New...") }
            Action { text: qsTr("&Open..."); onTriggered: console.log(ServersList.get(0)) }
            Action { text: qsTr("&Save") }
            Action { text: qsTr("Save &As...") }
            MenuSeparator { }
            Action { text: qsTr("&Quit"); onTriggered: Qt.quit()}
        }
        Menu {
            title: qsTr("&Edit")
            Action { text: qsTr("Cu&t") }
            Action { text: qsTr("&Copy") }
            Action { text: qsTr("&Paste") }
       }
       Menu {
            title: qsTr("&Help")
            Action { text: qsTr("&Settings..."); onTriggered: stack.push("SettingPage.qml") }
            Action { text: qsTr("&About"); onTriggered: aboutPopup.open() }
       }
    }

    StackView.onActivated: ()=>{
        if (TCPSocket.isConnected) return;
        console.log("fired")
        //debug++++++++++++++++++++++
        const _hostname = "127.0.0.1"
        const _port = 8787
        //+++++++++++++++++++++++++++
        //REDO!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        TCPSocket.serversGot.connect((e)=>{
            serversLoaderBusy.running = false
            ServersList.setServers(e)
        })
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        TCPSocket.connectToHost(_hostname, _port, _name)
    }

    readonly property bool inPortrait: window.width < 800
    readonly property bool onPage: stack.currentItem === welcomePage
    Drawer {
        id: drawer
        enabled: onPage
        y: menuBar.height
        width: 200
        height: window.height - menuBar.height
        modal: inPortrait
        interactive: inPortrait
        position: inPortrait ? 0 : 1
        visible: !inPortrait && onPage
//redo to fecthing serversList
        ListView {
          id: serversListView
          anchors.fill: parent
          model: ServersList
          spacing: 5
          currentIndex: -1
          highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
          delegate: Text {
              text: _server
              MouseArea {
                  anchors.fill: parent
                  onClicked: {
                      if (serversListView.currentIndex == index) return
                      personCardLoader.source = ""
                      serversListView.currentIndex = index
                      TCPSocket.connectToServer(index)
                      personCardLoader.setSource("PersonPage.qml",{"_card":_server,"_statusText":"...","_statusColor":"green"})
                  }
              }
          }
        }
        BusyIndicator {id: serversLoaderBusy; running: true } //WTF IS THAT?????
    }

    Item {
        id: mainContext
        x: inPortrait ? 0 : drawer.width
        width: parent.width - this.x
        height: parent.height
        Loader {id: personCardLoader; asynchronous: true; anchors.fill: parent }
        BusyIndicator {id: personCardLoaderBusy; running: personCardLoader.status == Loader.Loading } //WTF IS THAT?????
    }

    //may_be_put_in_qml_file_______________________________?
    Dialog {
        id: aboutPopup
        width: 150
        height: 200
        z:1
        parent: Overlay.overlay
        anchors.centerIn: parent
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        Text {anchors.centerIn: parent; text: qsTr("Made by: BON'Ka") }
    }
    //______________________________________________________?
}
