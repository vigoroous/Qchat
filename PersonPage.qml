import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

Page {
    id: personPage
    title: "personPage"
    anchors.fill: parent
    //custom objects also rework_____________________
    property string _card: ""
    property string _statusText: ""
    property string _statusColor: ""
    Frame {
        id: personFrame
        width: 100
        height: 100
        Column {
            y: 10
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2
            Text {id: _cardId; text: personPage._card}
            Row {
                Text {text: "Status: " }
                Text {id: _statusId; text:personPage._statusText; color:personPage._statusColor }
            }
            Switch {onToggled: _calling.running = !_calling.running }
        }
    }
    BusyIndicator {id: _calling; x: personFrame.width + 50; running: false}
    //_________________________________________________
}
