import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

Page {
    id: nextPage
    title: "nextPage"
    Rectangle {
        anchors.fill: parent
        color: "black"

        Text {
            id: wlkText
            anchors.centerIn: parent
            text: qsTr("Welcoming Page")
            color: "white"
            font.pixelSize: 20
        }
        Button {
            anchors.top: wlkText.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: wlkText.horizontalCenter
            text: qsTr("Next page")
            onClicked: stack.replace(stack.initialItem, "mainPage.qml")
        }
    }
        //__________________________________________________________?
}
