import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

Page {
	id: testAudioPage

	Button {
		width: 40
		height: 40
		anchors.right: parent.right
		Text {
			anchors.fill: parent
			anchors.margins: 1
			font.pixelSize: 40
			text: ""
		}
		onClicked: volumeManag.open()
	}
	Drawer {
        id: volumeManag
        width: 0.4 * parent.width
        height: parent.height
        edge: Qt.RightEdge
        ColumnLayout {
        	anchors{
        		left: parent.left
        		right: parent.right
        		top: parent.top
        	}
        	anchors.margins: 5
        	height: parent.height * 0.3
        	Row{ Text {text: "Input Volume: "} Text {text: Math.trunc(inputVol.position * 100)+"%"}}
        	Slider {
        		id:inputVol;  
        		value: 1.0;
        		implicitWidth: parent.width
        		onMoved: AudioBackend.inputVolume = position
        	}
        	Row{ Text {text: "Output Volume: "} Text {text: Math.trunc(outputVol.position * 100)+"%"}}
        	Slider {
        		id:outputVol; 
        		value: 1.0;
        		implicitWidth: parent.width
        		onMoved: AudioBackend.outputVolume = position
        	}
        	Row{ Text {text: "Notify interval: "} Text {text: Math.trunc(notfyInterval.value)+" ms"}}
        	Slider {
        		id:notfyInterval; 
        		from: 500
        		to: 2000
        		value: 1000;
        		implicitWidth: parent.width
        		onMoved: AudioBackend.notifyInterval = value
        	}
        	Button {
        		text: "debug"
        		onClicked : console.log(AudioBackend.notifyInterval);
        	}
        }
    }

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