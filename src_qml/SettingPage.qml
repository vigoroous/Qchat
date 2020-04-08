import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12
import Qt.labs.settings 1.0

Item {
    //Bruh..._styles_(delete_later)_________________________?
    Settings {
        id: settings
        property string style: "Default"
    }
    Page {
        id: settingsDialog
        focus: true
        title: "Settings"

        contentItem: ColumnLayout {
            id: settingsColumn
            spacing: 20

            RowLayout {
                spacing: 10

                Label {
                    text: "Style:"
                }

                ComboBox {
                    id: styleBox
                    Layout.fillWidth: true
                    property int styleIndex: -1
                    model: availableStyles
                    popup.z: 1
                    Component.onCompleted: {
                        styleIndex = find(settings.style, Qt.MatchFixedString)
                        if (styleIndex !== -1)
                            currentIndex = styleIndex
                    }
                }

                Label {
                    text: "Restart required"
                    color: "#e41e25"
                    opacity: styleBox.currentIndex !== styleBox.styleIndex ? 1.0 : 0.0
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
            RowLayout {
                spacing: 10
                Button {
                    text: "Exit"
                    onClicked: {
                        styleBox.currentIndex = styleBox.styleIndex
                        stack.pop()
                    }
                }
                Button {
                    text: "Ok"
                    onClicked: {
                        settings.style = styleBox.displayText
                        stack.pop()
                    }
                }
            }
        }
    }
    //______________________________________________________?
}
