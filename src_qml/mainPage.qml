import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

Page {
    id: welcomePage
    title: "welcomePage"
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

       ListView {
           /* TO_DO:
            * fetch_function to get listmodel dynamically by tcp
            */
           id: list
           anchors.fill: parent
           clip: true
           ScrollBar.vertical: ScrollBar{}
           model: AvailablePersons {}
           highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
           currentIndex: -1
           //rework delegate__________________________________________
           delegate: ItemDelegate {
               text: name + " (" + status + ")"
               MouseArea {
                   anchors.fill: parent
                   onClicked: {
                       if (personCardLoader.status === Loader.Loading) return
                       list.currentIndex = index
                       //reworkkk________________________________
                       // 0-Offline, 1-Online, 2-Sleep
                       var _statusText, _statusColor;
                       if (status === 0) {_statusText = "Offline"; _statusColor = "red"}
                       if (status === 1) {_statusText = "Online"; _statusColor = "green"}
                       if (status === 2) {_statusText = "Sleep"; _statusColor = "yellow"}
                       if (personCardLoader.status === Loader.Null) {
                           personCardLoader.setSource("PersonPage.qml", {"_card": name, "_statusText": _statusText, "_statusColor": _statusColor})
                       } else {
                           var currItem = personCardLoader.item
                           currItem._card = name; currItem._statusText = _statusText; currItem._statusColor = _statusColor
                       }
                       //________________________________________
                   }
               }
           }
           //_________________________________________________________
       }
    }
    Item {
        id: mainContext
        x: inPortrait ? 0 : drawer.width
        width: parent.width - this.x
        height: parent.height
        Loader {id: personCardLoader; asynchronous: true; anchors.fill: parent }
        BusyIndicator {id: personCardLoaderBusy; running: personCardLoader.status === Loader.Null } //WTF IS THAT?????
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
