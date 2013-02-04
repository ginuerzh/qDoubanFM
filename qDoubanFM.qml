// import QtQuick 1.0 // to target Maemo 5
import QtQuick 1.1

Item {
    width: 510
    height:245

    // album image in the left
    Image {
        id: albumImage
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit

        Component.onCompleted: {
            height = parent.height
            width = height
        }

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.2
            visible: tip.visible
        }

        Rectangle {
            id: tip
            width: 120
            height: 25
            color: "black"
            anchors.centerIn: parent
            opacity: 0.7
            visible: false

            Text {
                id: tipText
                anchors.centerIn: parent
                text: "查看专辑信息"
                color: "white"
                font.pointSize: 10
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                tip.visible = true
            }
            onExited: {
                tip.visible = false
            }
            onClicked: {
                Qt.openUrlExternally("http://music.douban.com/" + player.album)
            }
        }
    }

    Player {
        id: player
        anchors.left: albumImage.right
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        clip: true
        //color: "gray"
        Component.onCompleted: {
            height = parent.height
            //request();
        }
    }
}

