import QtQuick 1.1

Rectangle {
    //width: parent.width
    //height: 30
    color: "#e5e9ea"

    property alias label: title.text
    property alias labelWidth: title.width
    property alias text: textInput.text
    property alias echoMode: textInput.echoMode

    Text {
        id: title
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: 10
        //text: "帐 号"
    }
    TextInput {
        id: textInput
        anchors.left: title.right
        anchors.right: parent.right
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: 12
        focus: true
    }
}
