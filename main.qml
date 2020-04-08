import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQml.Models 2.14

ApplicationWindow {
    id: window
    width: 800
    height: 520
    visible: true

    StackView {
            id: stack
            initialItem: "src_qml/nextPage.qml"
            anchors.fill: parent
    }

}
