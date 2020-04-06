import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12
import Qt.labs.settings 1.0

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
            Action { text: qsTr("&Settings..."); onTriggered: settingsDialog.open() }
            Action { text: qsTr("&About"); onTriggered: aboutPopup.open() }
       }
    }

    readonly property bool inPortrait: window.width < 800
    Drawer {
        id: drawer
        y: header.height
        width: 200
        height: window.height - header.height
        modal: inPortrait
        interactive: inPortrait
        position: inPortrait ? 0 : 1
        visible: !inPortrait

       ListView {
           id: list
           anchors.fill: parent
           clip: true
           ScrollBar.vertical: ScrollBar{}
           model: AvailablePersons {}
           highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
           //rework delegate__________________________________________
           delegate: ItemDelegate {
               text: name + " (" + status + ")"
               MouseArea {
                   anchors.fill: parent
                   onClicked: {
                       list.currentIndex = index
                       //there we'll be fetching person
                       _card.text = name
                       //bullshit need rework_________________________
                       _status.text = status
                       if (status === "offline") _status.color = "red"
                       if (status === "sleep") _status.color = "yellow"
                       if (status === "online") _status.color = "green"
                       //_____________________________________________
                   }
               }
           }
           //_________________________________________________________
       }
    }
    Item {
        id: mainContext
        height: parent.height
        width: inPortrait ? parent.width : parent.width - drawer.width * drawer.position
        x: inPortrait ? 0 : drawer.width * drawer.position

        //custom objects also rework_____________________
        Frame {
            anchors.centerIn: parent
            width: 100
            height: 100
            Column {
                y: 10
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 2
                Text {id: _card }
                Row {
                    Text {text: "Status: " }
                    Text {id: _status }
                }
                Switch {onToggled: _calling.running = !_calling.running }
            }
        }
        BusyIndicator {id: _calling; anchors.horizontalCenter: parent.horizontalCenter; running: false}
        //_________________________________________________

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
    //Bruh..._styles_(delete_later)_________________________?
    Settings {
        id: settings
        property string style: "Default"
    }
    Dialog {
        id: settingsDialog
        z:1
        x: Math.round((window.width - width) / 2)
        y: Math.round(window.height / 6)
        width: Math.round(Math.min(window.width, window.height) / 3 * 2)
        modal: true
        focus: true
        title: "Settings"

        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            settings.style = styleBox.displayText
            settingsDialog.close()
        }
        onRejected: {
            styleBox.currentIndex = styleBox.styleIndex
            settingsDialog.close()
        }

        contentItem: ColumnLayout {
            id: settingsColumn
            spacing: 20

            RowLayout {
                spacing: 10

                Label {
                    text: "Style:"
                }

                ComboBox {
                    id: styleBox
                    Layout.fillWidth: true
                    property int styleIndex: -1
                    model: availableStyles
                    popup.z: 1
                    Component.onCompleted: {
                        styleIndex = find(settings.style, Qt.MatchFixedString)
                        if (styleIndex !== -1)
                            currentIndex = styleIndex
                    }
                }

                Label {
                    text: "Restart required"
                    color: "#e41e25"
                    opacity: styleBox.currentIndex !== styleBox.styleIndex ? 1.0 : 0.0
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
    //______________________________________________________?
}
