import QtQuick 1.1
import QtMultimediaKit 1.1

Rectangle {
    id: player

    property int channel: 1
    property alias channelLabel: channelText.text
    property variant song /*: {
                "picture": "",
                "albumtitle": "",
                "adtype": 0,
                "company": "",
                "rating_avg": 0.0,
                "public_time":"",
                "ssid": "",
                "album": "",
                "like": 0,
                "artist": "",
                "url": "",
                "title": "",
                "subtype": "",
                "length": 0,
                "sid": "",
                "aid": ""
    }
    */

    property int like
    // when song list is ready, load next song at once
    property bool rapidLoad: true
    property string sid: "0"
    property string album: ""
    property bool logined: false


    onSongChanged: {
        player.state = "play";
    }

    onChannelChanged: {
        player.newChannel();
    }

    Column {
        id: columnView
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        Rectangle {
            id: header
            width: parent.width
            height: 25

            Text {
                id: login
                height: parent.height
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "登录"
                font.pointSize: 12
                //font.underline: true
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.color = "gray"
                    onExited: parent.color = "black"
                    onClicked: loader.source = "LoginForm.qml"
                }
            }
            Row {
                id: userinfo
                anchors.right: parent.right
                visible: false

                Text {
                    id: username
                }

                Image {
                    height: 15
                    width: height + 5
                    fillMode: Image.PreserveAspectFit
                    source: "unlike.png"
                }
                Text {
                    id: played
                    property int count: 0
                    text: count.toString()
                }
                Image {
                    height: 15
                    width: height + 5
                    fillMode: Image.PreserveAspectFit
                    source: "like.png"
                }
                Text {
                    id: liked
                    property int count: 0
                    text: count.toString()
                }
                Image {
                    height: 15
                    width: height
                    fillMode: Image.PreserveAspectFit
                    source: "trash.png"
                }
                Text {
                    id: banned
                    property int count: 0
                    text: count.toString()
                }

                Text {
                    id: logout
                    text: " 退出"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = "gray"
                        onExited: parent.color = "black"
                        onClicked: {
                            player.logout();
                        }
                    }
                }
            }
        }

        Text {
            id: artistText
            text: "Artist"
            font.pointSize: 20
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            id: albumTitle
            text: "< Album > 2013"
            font.pointSize: 12
        }

        // song name and channel
        Row {
            width: parent.width
            height: 40
            spacing: 5

            Text {
                id: songName
                width: parent.width - channelButton.width - parent.spacing
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 2
                text: "Title"
                font.pointSize: 11
                color: "green"
                clip: true
            }

            Rectangle {
                id: channelButton
                width: channelText.width + 6
                height: channelText.height + 2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 2
                color: "gray"

                Text {
                    id: channelText
                    anchors.centerIn: parent
                    text: "华语 MHz"
                    color: "white"
                    font.pointSize: 11
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        parent.color = "darkgray";
                    }
                    onExited: {
                        parent.color = "gray";
                    }
                    onClicked: {
                        loader.source = "ChannelList.qml"
                    }
                }
            }
        }
        // progress bar
        ProgressBar {
            id: progressBar
            width: parent.width
            height: 12
            bgc: "lightgray"
            fgc: "green"
            max: songAudio.duration
        }

        // duration time
        Text {
            id: timeout
            text: "0:00"
            anchors.right: parent.right
            font.pointSize: 11
            font.letterSpacing: 1

            Timer {
                id: timer
                interval: 100
                repeat: true
                triggeredOnStart: true

                onTriggered: {
                    var dur = songAudio.duration - songAudio.position;

                    if (dur >= 0) {
                        var min = Math.floor(dur / (1000 * 60)) % 60;
                        var second = Math.floor(dur / 1000) % 60;
                        timeout.text = "-" + min + ":" + (second < 10 ? "0" + second : second);
                        progressBar.position = songAudio.position;
                    }
                }
            }
        }

        // song control
        Rectangle {
            id: playControl
            width: parent.width
            height: 95
            //color: "darkgray"

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 30

                Image {
                    id: rateImg
                    source: "unlike.png"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            parent.opacity = 0.8;
                        }
                        onExited: parent.opacity = 1.0
                        onClicked: {
                            player.like = !player.like;
                            player.rate(player.like);
                        }
                    }

                    Connections {
                        target: player
                        onLikeChanged: {
                            rateImg.source = player.like ? "like.png" : "unlike.png";
                        }
                    }
                }
                Image {
                    source: "trash.png"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.opacity = 0.8
                        onExited: parent.opacity = 1.0
                        onClicked: player.trash();
                    }
                }

                Text {
                    width: 30
                    height: 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "II"
                    font.weight: Font.Bold
                    font.pointSize: 25
                    color: "#554343"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.opacity = 0.8
                        onExited: parent.opacity = 1.0
                        onClicked: {
                            loader.source = "Pause.qml"
                            songAudio.pause();
                        }
                    }
                }

                Image {
                    source: "next.png"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.opacity = 0.8
                        onExited: parent.opacity = 1.0
                        onClicked: player.skip();
                    }
                }
            }
        }
    }

    Audio {
        id: songAudio
        autoLoad: true

        onStatusChanged: {
            if (status == Audio.EndOfMedia) {
                player.endReport();
                nextSong();
            } else if (status == Audio.Loaded) {
                //console.log("loaded");
                play();
            } else if (status == Audio.Buffered) {
                //console.log("Buffered");
                timer.restart();
            }
            /*else if (status == Audio.Loading) {
                console.log("loading");
            }  else if (status == Audio.Stalled) {
                console.log("stalled");
            } else if (status == Audio.InvalidMedia) {
                console.log("InvalidMedia");
            } else if (status == Audio.UnknownStatus) {
                console.log("UnknownStatus");
            } else if (status == Audio.NoMedia) {
                console.log("NoMedia")
            }
            */
        }
    }

    //Element loader
    Loader {
        id: loader
        width: parent.width
        height: columnView.height

        onSourceChanged: {
            if (source.toString().length > 0) {
                columnView.enabled = false;
            } else {
                columnView.enabled = true;
            }
        }
    }

    states: State {
        name: "play"

        PropertyChanges {
            target: player
            sid: song.sid ? song.sid : "0"
            like: song.like
            album: song.album

        }
        PropertyChanges { target: artistText; text: player.song.artist }
        PropertyChanges {
            target: albumTitle
            text: "< " + player.song.albumtitle + " > " +
                  (player.song.public_time ? player.song.public_time : "")
        }
        PropertyChanges { target: songName; text: player.song.title }
        PropertyChanges {
            target: songAudio
            source: song.url
        }
        // use large picture, default is middle size
        PropertyChanges {
            target: albumImage; source: player.song.picture.replace(/mpic/, "lpic")
        }
    }

    JSONListModel {
        id: statusModel
        query: "$"
        clear: true

        onJsonChanged: {
            if (count > 0) {
                var o = model.get(0);
                if (o.r === 0) {
                    //console.log(json)
                    songModel.json = json;
                } else {
                    console.log(o.err);
                }
            } else {
                console.log(json);
            }
        }
    }

    JSONListModel {
        id: songModel
        query: "$.song[*]"
        clear: false

        onJsonChanged: {
            if (count > 0) {
                player.nextSong();
            } else {
                console.log("error, no song in list");
            }
        }
    }

    JSONListModel {
        id: userModel
        query: "$.user_info"
        clear: true

        onJsonChanged: {
            if (count > 0) {
                player.logined = true;  // login valid
            }
            loader.source = "";
        }
    }

    onLoginedChanged: {
        if (player.logined) {
            var o = userModel.model.get(0);
            username.text = o.name;
            played.count =o.play_record.played;
            liked.count = o.play_record.liked;
            banned.count = o.play_record.banned;

            userinfo.visible = true;
            login.visible = false;
        } else {
            userinfo.visible = false;
            login.visible = true;
        }

    }

    Component.onCompleted: {
        newChannel();
    }

    function nextSong() {
        if (songModel.count == 0) {
            player.newSongs();  // song list is empty, request new song list.
            return false;
        }

        console.log("song list: " + songModel.count);

        if (!player.rapidLoad) {
            return false;
        }
        player.state = "" // the init state : stop

       player.song = songModel.model.get(0);
        songModel.model.remove(0);

        return true;
    }

    function request(type) {
        var url = "http://douban.fm/j/mine/playlist?" + parameter(type);
        console.log(url)
        if (type !== "e") {
            console.log("song list clear");
            songModel.model.clear();
        }
        statusModel.source = url;
    }

    function newChannel() {
        player.rapidLoad = true;
        request("n");
    }
    function endReport() {
        player.rapidLoad = true;
        request("e");
    }
    function skip() {
        player.rapidLoad = true;
        request("s")
    }
    function newSongs() {
        player.rapidLoad = true;
        request("p")
    }
    function trash() {
        player.rapidLoad = true;
        request("b");
    }
    function rate(like) {
        player.rapidLoad = false;

        if (like)
            request("r");
        else
            request("u");
    }

    function parameter(type) {
        var r = new Number(Math.round(Math.random() * 0xF000000000) + 0x1000000000).toString(16);
        var s = "";
        s += ("type=" + type);
        s += ("&channel=" + player.channel);
        s += ("&sid=" + player.sid);
        s += ("&pt=" + Math.round(songAudio.position / 1000));
        s += ("&r=" + r);
        s += ("&pb=64&from=mainsite");

        return s;
    }

    function logout() {
        var url = "http://douban.fm/partner/logout?source=radio&no_login=y&ck=" +
                userModel.model.get(0).ck;
        var doc = new XMLHttpRequest;
        console.log(url);
        doc.open("GET", url);
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE && doc.status === 200) {
                //console.log(doc.responseText);
                player.logined = false;
            }
        }
        doc.send();
    }
}
