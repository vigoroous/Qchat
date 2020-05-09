import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

Page {
	id: testAudioPage
	ColumnLayout {
		anchors.fill: parent
		spacing: 2
		Text {
        	Layout.alignment: Qt.AlignCenter
			text: "to be available devices"
		}

        Rectangle {
            width: 200
            height: 20
            border.color: "lightblue"
            border.width: 2
            radius: 10
            color: "white"
            Layout.alignment: Qt.AlignCenter
            TextInput {
                id: tstImput
                anchors.fill: parent
                anchors.margins: 3
                color: "black"
            }
        }

		RowLayout {
			spacing: 10
        	Layout.alignment: Qt.AlignCenter
			Button {
				text: "Connect"
				onClicked: AudioBackend.connectSocket("127.0.0.1", 9090)
			}
			Button {
				id: dscnBtn
				text: "Disconnect"
				enabled: AudioBackend.isConnected
				onClicked: AudioBackend.disconnectSocket()
			}
			Button {
				text: "ToggleStream"
				onClicked: AudioBackend.toggleStream()
			}
			Connections {
            	target: AudioBackend
            	onError: {
            	    console.log(err)
            	}
        	} 
		}
	}
}