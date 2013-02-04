import QtQuick 1.1

// pause rectangle
Item {
    id: pauseRect
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        opacity: 0.8
    }

    Text {
        anchors.centerIn: parent
        font.pointSize: 11
        text: "继续收听 >"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            loader.source = "";
            songAudio.play();
        }
    }
}
