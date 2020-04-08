import QtQuick 2.0
import QtQuick.Controls 2.14

Popup {
    id: aboutPopup
    anchors.centerIn: parent
    width: 200
    height: 300
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    Text {
        text: qsTr("Made by: BON'Ka")
    }
}
