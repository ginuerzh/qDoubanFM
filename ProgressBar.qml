import QtQuick 1.1

Item {
    property int min: 0
    property int max: 100
    property int position: 0
    property alias bgc: bar.color
    property alias fgc: hightlight.color

    id: progressBar
    clip: true

    Rectangle {
        id: bar
        width: parent.width
        height: 3
        anchors.verticalCenter: parent.verticalCenter
        //color: "lightgray"

        Rectangle {
            id: hightlight
            height: parent.height
            //color: "green"
        }

        Behavior on height{
            NumberAnimation { duration: 300 }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                bar.height = 12;
            }
            onExited: {
                bar.height = 3;
            }

            onClicked: {
                //console.log("progress bar clicked")
                if (songAudio.seekable) {
                    songAudio.position = Math.floor((mouse.x / parent.width) * (progressBar.max -progressBar.min) + progressBar.min)
                }
            }
        }
    }

    onPositionChanged: {
        if (max > min && position >= min && position <= max)
            hightlight.width = (progressBar.position - min) / (max - min) * width;
        else
            hightlight.width = 0;
    }
}

