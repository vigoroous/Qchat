import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQml.Models 2.14

ApplicationWindow {
    id: window
    width: 800
    height: 520
    visible: true

    header: Rectangle {
        id: windowHeader
        height: 40
        width: parent.width

        ObjectModel {
            id:buttonRow
            Button {
                text: "pop"
                Layout.alignment: Qt.AlignLeft
                enabled: stack.depth > 1
                onClicked: {
                    stack.pop()
                    var pos = buttonRow.count-2
                    var elem = buttonRow.get(pos)
                    buttonRow.remove(pos)
                    elem.destroy()
                    console.log(elem)
                }
            }
            Button {
                id: pushButton
                text: "push"
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    stack.push("MainPage.qml")
                    var newComp = Qt.createComponent("DynButton.qml");
                    if (newComp.status === Component.Ready) {
                        var newObj = newComp.createObject()
                        newObj.text = stack.depth
                        newObj.index = stack.depth
                        buttonRow.insert(buttonRow.count-1, newObj)
                    }
                }
            }
        }

       RowLayout {
           anchors.fill: parent
           Repeater {
               model: buttonRow
           }
       }
    }

    StackView {
            id: stack
            initialItem: NextPage {}
            anchors.fill: parent
    }

}
