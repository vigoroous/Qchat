import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

Page {
    id: welcomePage
    title: "welcomePage"
    header: Rectangle {
        id: mainHeader
        width: parent.width
        height: 40
        color: "orange"
        RowLayout {
            anchors.fill: parent
            Text {
                text: qsTr("Main Page")
                Layout.alignment: Qt.AlignCenter
            }
        }
    }

    property bool inPortrait:{
       if (sidePanel.show === 0) return window.width > 700
       if (sidePanel.show === 1) return true
       if (sidePanel.show === 2) return false
    }

    Rectangle {
        id: sidePanel
        width: currentWidth
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        visible: inPortrait
        color: "blue"

        property int show: 0 //0-normal; 1-forcedOpen; 2-forcedClose
        property int currentWidth: 200
        property int lastX: 0

        Rectangle {
            id: resizeBar
            width: 5
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            color: "yellow"
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeHorCursor
                onClicked: console.log(sidePanel.lastX = mouseX)
                onMouseXChanged: sidePanel.currentWidth += mouseX - sidePanel.lastX - 2
            }
        }

        ListView {
            id: mainWindowList
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            model: AvailablePersons {}
            delegate: Item {
                id: wrapper
                width: sidePanel.currentWidth - resizeBar.width; height: 40
                Column {
                    Text { text: '<b>Name:</b> ' + name }
                    Text { text: '<b>Status:</b> ' + status }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mainWindowList.currentIndex = index
                        personCard.personText = name + " : " + status
                    }
                }
            }
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        }
    }

    Item {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        x: inPortrait ? sidePanel.width : 0

        Rectangle {
            id: showButton
            width: 100
            height: 100
            color: inPortrait ? "green" : "red"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (sidePanel.show === 0)
                        if (window.width > 700) {sidePanel.show = 2} else {sidePanel.show = 1}
                    else
                        if (sidePanel.show === 1) {sidePanel.show = 2} else {sidePanel.show = 1}
                }
            }
        }

        Item {
            id: personCard
            visible: this.personText === "" ? false : true
            property string personText: ""

            Rectangle {
                x: 150
                height: 50
                width: 50
                color: "grey"
            }
            Text {
                x: 150
                y: 150
                text: qsTr(parent.personText)
            }
        }
    }

}
