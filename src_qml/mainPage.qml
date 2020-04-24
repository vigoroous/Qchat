import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

//CUTOM_IMPORT____________________________
import usr.socketBackend 1.0
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
            Action { text: qsTr("&Open...") }
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
        Loader {id: serversLoader; asynchronous: true; anchors.fill: parent }
        BusyIndicator {id: serversLoaderBusy; running: true } //WTF IS THAT?????

       /*
       ListView {
           id: list
           anchors.fill: parent
           clip: true
           ScrollBar.vertical: ScrollBar{}
           model: AvailablePersons { id:listmodel }
           highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
           currentIndex: -1
           //rework delegate__________________________________________
           delegate: ItemDelegate {
               text: name + " (" + status + ")"
               MouseArea {
                   anchors.fill: parent
                   onClicked: {
                       //reworkkk_(if connection pending and etc...)____________________________________________
                       if (list.currentIndex === index) return
                       if (tcpSocket.isConnected() || personCardLoader.source) {
                           personCardLoader.source = ""
                           tcpSocket.disconnectFromHost()
                       }
                       personCardLoaderBusy.running = true
                       tcpSocket.callbackOnConnect = function _connFunc() {
                           if (personCardLoader.status === Loader.Loading) return
                           list.currentIndex = index
                           if (personCardLoader.status === Loader.Null)
                               personCardLoader.setSource("PersonPage.qml", {"_card": name, "_statusText": "Online", "_statusColor": "Green"})
                       }
                       tcpSocket.callbackOnDisconnect = function _diconnFunc() {
                           if (personCardLoader.status === Loader.Loading) {
                               //handle disconnect before load!!!!!!!!!!!!!!!!!!!!!!!!
                               personCardLoader.source = ""
                           }
                           if (personCardLoader.status === Loader.Ready) {
                               var currItem = personCardLoader.item
                               currItem._statusText = "Offline"; currItem._statusColor = "Red"
                           }
                       }
                       //debug++++++++++++++++++++++
                       const _hostname = "127.0.0.1"
                       const _port = 8787
                       //+++++++++++++++++++++++++++
                       tcpSocket.connectToHost(_hostname, _port)
                       //______________________________________________________________________________________
                   }
               }
           }
           //_________________________________________________________
       }
       */

       //REWORKKK_____________________________________________________
       TCPSocket {
           id: tcpSocket
           onErrorSending: cosole.log(errMsg)
           //ACHTUNG!FUCK!CALLBACKS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
           property var callbackOnConnect: null
           //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
           //ACHTUNG!FUCK!CALLBACKS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
           property var callbackOnDisconnect: null
           //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
           onServersGot: {
               serversList.setServers(serversArr)
           }
           onDisconnected: {
               if (!callbackOnDisconnect) return console.log("error on calling callbackDisconnectFunc: " + callbackOnDisconnect);
               callbackOnDisconnect();
           }
       }
       //_____________________________________________________________

       ServersList {
           id: serversList

       }

    }
    Item {
        id: mainContext
        x: inPortrait ? 0 : drawer.width
        width: parent.width - this.x
        height: parent.height
        Loader {id: personCardLoader; asynchronous: true; anchors.fill: parent }
        BusyIndicator {id: personCardLoaderBusy; running: false } //WTF IS THAT?????
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
