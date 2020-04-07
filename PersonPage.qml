import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

Page {
    id: personPage
    title: "personPage"
    anchors.fill: parent
    property string _card: ""
    property string _statusText: ""
    property string _statusColor: ""
    Frame {
        id: personFrame
        anchors.fill: parent
        Rectangle {
            id: callpanel
            height: 200
            width: 200
            color: "lightgrey"
            Column {
                spacing: 2
                Text { text: _card}
                Row {
                    Text{text: "status: "}
                    Text{text: _statusText; color: _statusColor}
                }
            }
        }
        ListView {
            /* TO_DO:
             * fetch function to get MessagesList dynamically by tcp
             */
            y: callpanel.height
            width: 200
            height: inputPanel.y - this.y
            spacing: 5
            clip: true
            ScrollBar.vertical: ScrollBar{policy: ScrollBar.AlwaysOn }
            model: MessagesList {}
            delegate: Text {text: _text; color: "black"}
        }
        Row {
            id: inputPanel
            y:parent.height * 0.8
            x:parent.width * 0.3
            spacing: 10
            TextField {
            }
            Button {
                text: "send"
            }
        }
    }
}
