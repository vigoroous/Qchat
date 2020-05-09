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
		GridLayout {
    		columns: 2
        	Layout.alignment: Qt.AlignCenter    		
    		Text {text: "server adress"}
    		Text {text: "port"}
    		Rectangle {
                width: 80
                height: 20
                border.color: "blue"
                border.width: 2
    			TextInput {anchors.fill: parent; anchors.margins: 5; id: addr}
    		}
    		Rectangle {
                width: 40
                height: 20
                border.color: "blue"
                border.width: 2
    			TextInput {anchors.fill: parent; anchors.margins: 5; id: port}  
    		}  		
		}

		RowLayout {
			spacing: 10
        	Layout.alignment: Qt.AlignCenter
			Button {
				text: "Connect"
				onClicked: {
					if (!addr.text || !port.text) AudioBackend.connectSocket("127.0.0.1", 9090)
					else AudioBackend.connectSocket(addr.text, port.text)
				}
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