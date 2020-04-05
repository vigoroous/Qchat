import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: window
    width: 800
    height: 520
    visible: true

    header: Rectangle {
        id: windowHeader
        height: 40
        width: parent.width
        RowLayout {
            anchors.fill: parent
            Button {
                text: "pop"
                Layout.alignment: Qt.AlignLeft
                enabled: stack.depth > 0
                onClicked: {
                    if (stack.depth === 1) {
                        console.log("lul fuck u")
                        return
                    }
                    stack.pop()
                }
            }
            Button {
                text: "push"
                Layout.alignment: Qt.AlignRight
                onClicked: stack.push("qrc:/NextPage.qml")
            }
        }
    }

    StackView {
            id: stack
            initialItem: MainPage {}
            anchors.fill: parent
    }
}
