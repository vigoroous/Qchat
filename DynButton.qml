import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12

Button {
    Layout.alignment: Qt.AlignCenter
    onClicked: (console.log(this.text))
}
