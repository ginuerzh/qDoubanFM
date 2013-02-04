import QtQuick 1.1

Rectangle {
    id: channelList
    color: "black"
    opacity: 0.8

    Flickable {
        anchors.fill: parent
        anchors.margins: 10
        contentWidth: channels.width
        flickableDirection: Flickable.HorizontalFlick
        clip: true

        Grid {
            id: channels
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8
            rows: 2

            Repeater {
                model: channelModel
                Rectangle {
                    width:76
                    height: 70
                    color: ((player.channel === cid) ? "darkgray" : "gray")
                    radius: 5
                    smooth: true

                    Text {
                        anchors.centerIn: parent
                        text: channel
                        font.pointSize: 10
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = "lightgray";
                        onExited: parent.color = ((player.channel === cid) ? "darkgray" : "gray");
                        onClicked: {
                            if (cid <= 0 && !player.logined) {
                                loader.source = "LoginForm.qml";
                            } else {
                                player.channel = cid
                                player.channelLabel = channel + " MHz"
                                loader.source = "";
                            }
                        }
                    }
                }
            }

            ListModel {
                id: channelModel
                ListElement { cid: 0; channel: "我的私人" }
                ListElement { cid: -3; channel: "我的红星" }
                ListElement { cid: 1; channel: "华语" }
                ListElement { cid: 6; channel: "粤语" }
                ListElement { cid: 2;  channel: "欧美" }
                ListElement { cid: 22;  channel: "法语" }
                ListElement { cid: 17; channel: "日语" }
                ListElement { cid: 18; channel: "韩语" }
                ListElement { cid: 3; channel: "70" }
                ListElement { cid: 4; channel: "80" }
                ListElement { cid: 5; channel: "90" }
                ListElement { cid: 7; channel: "摇滚" }
                ListElement { cid: 8; channel: "民谣" }
                ListElement { cid: 9; channel: "轻音乐" }
                ListElement { cid: 10; channel: "电影原声" }
                ListElement { cid: 13; channel: "爵士" }
                ListElement { cid: 14; channel: "电子" }
                ListElement { cid: 15; channel: "说唱" }
                ListElement { cid: 16; channel: "R&B" }
                ListElement { cid: 20; channel: "女生" }
            }
        }
    }
}
