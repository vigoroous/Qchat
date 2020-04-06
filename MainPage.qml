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
            Action { text: qsTr("&About"); onTriggered: aboutPopup.open() }
       }
    }
    /* Need massive rework (drawer gets infront)*/
    Popup {
        id: aboutPopup
        anchors.centerIn: parent
        width: 200
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        Text {
            text: qsTr("Made by: BON'Ka")
        }
    }
    /* Need work on animation */
    readonly property bool inPortrait: window.width > 600
    Drawer {
        id: drawer
        y: header.height
        width: 200
        height: window.height - header.height
        modal: !inPortrait
        interactive: !inPortrait
        position: inPortrait ? 0 : 1
        visible: inPortrait

        ScrollView {
            anchors.fill: parent
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ListView {
                anchors.fill: parent
                model: 20
                delegate: ItemDelegate {
                    text: "Item " + index
                }
            }
        }
    }
    Item {
        id: mainContext
        height: parent.height
        width: parent.width - drawer.width * drawer.position
        x: drawer.width * drawer.position

        //custom objects
        Rectangle {
            anchors.centerIn: parent
            width: 100
            height: 100
            color: "black"
        }
    }
}
