import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

Page { 
    id: nextPage
    title: "nextPage"

    function handleInput() {
        if (_testAudio.checkState === Qt.Checked) {
            stack.replace(stack.initialItem, "test/TestAudioPage.qml");
            return;
        }
        
        let _name = wlkInput.text;
        if (!_name) {
            //rework to tooltip or popup or outline______________________
            console.log("enter name");
            //___________________________________________________________
            return;
        }
        stack.replace(stack.initialItem, "mainPage.qml", {"_name": _name});
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        ColumnLayout{
            anchors.fill: parent
            spacing: 5
            CheckBox {
                id: _testAudio
                checked: true
                Layout.alignment: Qt.AlignCenter
                text: "TestAudio"
            }
            Text {
                id: wlkText
                text: qsTr("Enter your name:")
                color: "white"
                font.pixelSize: 20
                Layout.alignment: Qt.AlignCenter
            }
            Rectangle {
                width: 100
                height: 30
                border.color: "lightgrey"
                border.width: 2
                radius: 10
                color: "white"
                Layout.alignment: Qt.AlignCenter
                TextInput {
                    id: wlkInput
                    anchors.fill: parent
                    anchors.margins: 3
                    color: "black"
                    focus: true
                    Keys.onPressed: {if (event.key === Qt.Key_Return) handleInput()}
                }
            }
            Button {
                id:wlkButton
                text: qsTr("Next page")
                Layout.alignment: Qt.AlignCenter
                onClicked: handleInput()
            }
        }
    }
}