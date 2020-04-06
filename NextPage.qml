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
            anchors.centerIn: parent
            text: qsTr("Welcoming Page")
            color: "white"
            font.pixelSize: 20
        }
    }
}
