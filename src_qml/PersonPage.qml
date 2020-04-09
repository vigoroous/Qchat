import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

//CUTOM_IMPORT____________________________
import usr.msgList 1.0
//________________________________________

Page {
    id: personPage
    title: "personPage"
    property string _card: ""
    property string _statusText: ""
    property string _statusColor: ""
    contentItem: Frame {
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
            id: messageList
            anchors {
                top: callpanel.bottom
                bottom: inputPanel.top
                topMargin: 5
                bottomMargin: 5
            }
            width: parent.width
            spacing: 5
            clip: true
            ScrollBar.vertical: ScrollBar {policy: ScrollBar.AsNeeded }
            model: MsgListModel {id: msgListModel}
            delegate: Rectangle {
                width: parent.width
                height: messageDelegate.paintedHeight
                color: "lightgrey"
                border.color: msgDlgHndl.containsMouse ? "lightgreen" : "lightred"
                Text {id: messageDelegate; text: _text; color: "black"}
                MouseArea {id: msgDlgHndl; anchors.fill: parent; hoverEnabled: true}
            }
        }
        Row {
            id: inputPanel
            y:parent.height - height
            width: parent.width
            height: 50
            spacing: 10
            //Definetly_rework____Rectangle________________________
            Rectangle {
                id: textAreaWrapper
                height: parent.height
                width: parent.width
                color: "lightblue"
                border.color: textArea.activeFocus ? "blue" : "grey"
                border.width: 1
                ScrollView {
                    anchors.fill: parent
                    clip: true
                    TextArea{
                        id: textArea
                        textFormat: Qt.PlainText
                        wrapMode: TextArea.Wrap
                        focus: true
                        selectByMouse: true
                        persistentSelection: true
                        placeholderText: qsTr("Start typing here......");
                        MouseArea {
                            acceptedButtons: Qt.RightButton
                            anchors.fill: parent
                            cursorShape: Qt.IBeamCursor
                            onClicked: contextMenu.popup(mouse.x,mouse.y-contextMenu.height)
                        }
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return){
                                event.accepted = true
                                if (event.modifiers & Qt.ControlModifier) {
                                    var pos = textArea.cursorPosition
                                    textArea.insert(pos,'\n')
                                } else {
                                    if (!textArea.text) return
                                    msgListModel.addMessage(textArea.text)
                                    textArea.text = ""
                                    messageList.positionViewAtEnd()
                                }
                            }
                        }
                    }
                }
                Menu {
                    id: contextMenu
                    MenuItem {
                        text: qsTr("Copy")
                        enabled: textArea.selectedText
                        onTriggered: textArea.copy()
                    }
                    MenuItem {
                        text: qsTr("Cut")
                        enabled: textArea.selectedText
                        onTriggered: textArea.cut()
                    }
                    MenuItem {
                        text: qsTr("Paste")
                        enabled: textArea.canPaste
                        onTriggered: textArea.paste()
                    }
                }
            }
            //____________________________________________________________________
        }
    }
}
