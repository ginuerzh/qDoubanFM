import QtQuick 1.1

Item {
    id: loginForm

    Rectangle {
        anchors.fill: parent
        opacity: 0.95
    }

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 8

        Text {
            height: 25
            text: "登 录"
            font.pointSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: errMsg
            width: parent.width
            font.pointSize: 12
            color: "red"
            text: " "
        }
        FormInput {
            id: username
            width: parent.width
            height: 35
            label: "帐    号:"
            focus: true
        }
        FormInput {
            id: password
            width: parent.width
            height: 35
            echoMode: TextInput.Password
            label: "密    码:"
        }

        Row {
            width: parent.width
            spacing: 5

            FormInput {
                id: captcha
                width: 130
                height: 35
                label: "验证码:"
            }
            Rectangle {
                width: 110
                height: 35
                //color: "#d7cbcb"
                border.color: "#d7cbcb"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "点击获取验证码"
                }

                Image {
                    anchors.fill: parent
                    property string captchaId: ""
                    id: captchaImg
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: getCaptcha();
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 30
            //color: "gray"

            Text {
                id: autoLogin
                width: 120
                anchors.verticalCenter: parent.verticalCenter
                //text: "下次自动登录"
            }

            Rectangle {
                id: loginButton
                width: 60
                height: 30
                anchors.right: cancelButton.left
                anchors.rightMargin: 10
                color: "#92d9f3"

                Text {
                    id: loginText
                    anchors.centerIn: parent
                    text: "登 录"
                    color: "white"
                    font.pointSize: 11
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        loginText.color = "black"
                        parent.color = "#b1e5f7"
                    }
                    onExited: {
                        loginText.color = "white"
                        parent.color = "#92d9f3"
                    }
                    onClicked: {
                        console.log("login");
                        login();
                    }
                }
            }
            Rectangle {
                id: cancelButton
                width: 60
                height: 30
                anchors.right: parent.right
                color: "#92d9f3"

                Text {
                    id: cancelText
                    anchors.centerIn: parent
                    text: "取 消"
                    color: "white"
                    font.pointSize: 11
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        cancelText.color = "black"
                        parent.color = "#b1e5f7"
                    }
                    onExited: {
                        cancelText.color = "white"
                        parent.color = "#92d9f3"
                    }

                    onClicked: loader.source = ""
                }
            }
        }
    }

    JSONListModel {
        id: loginStatus
        query: "$"
        clear: true

        onJsonChanged: {
            if (count > 0) {
                var o = model.get(0);
                if (o.r === 0) {
                    userModel.json = json;
                    player.logined = true;
                } else {
                    errMsg.text = o.err_msg;
                    if (o.err_no === 1011) {    // captcha error
                        getCaptcha();
                    }
                }
            } else {
                console.log(json);
            }
        }
    }

    function getCaptcha() {
        var url ="http://douban.fm/j/new_captcha"; // get captchaId
        var source ="http://douban.fm/misc/captcha" + "?size=m&id=";    // get captcha

        var doc = new XMLHttpRequest;
        doc.open("GET", url);
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE && doc.status === 200) {
                var captchaId = doc.responseText;
                //console.log(doc.responseText);
                captchaId = captchaId.substring(1, captchaId.indexOf("\"", 1));
                //console.log("captcha ID:[" + captchaId + "]");
                captchaImg.captchaId = captchaId;
                captchaImg.source = source + captchaId;
                //console.log(captchaImg.source);
            }

        }
        doc.send();
    }

    function login() {
        var url ="http://douban.fm/j/login";
        var doc = new XMLHttpRequest;
        doc.open("POST", url);
        doc.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                //console.log(doc.status);
                //console.log(doc.responseText);
                if (doc.status === 200) {
                    loginStatus.json = doc.responseText;
                }
            }
        }
        doc.send("source=radio" +
                 "&alias=" + username.text +
                 "&form_password=" + password.text +
                 "&captcha_solution=" + captcha.text +
                 "&captcha_id=" + captchaImg.captchaId +
                 "&task=sync_channel_list"
                 );
    }

}
