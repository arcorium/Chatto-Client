

import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Material
import arc.component
import arc.controller

Rectangle {
    id: rectangle
    anchors.fill: parent
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#2c2c2c"
        }
        GradientStop {
            position: 1
            color: "#363636"
        }
    }

    Pane {
        id: card
        width: 400
        height: 400

        Material.elevation: 20
        anchors.verticalCenter: parent.verticalCenter
        horizontalPadding: 0
        bottomPadding: 0
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            anchors.fill: parent
            TextField {
                id: username_tf
                y: 185
                text: ""
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 40
                anchors.rightMargin: 40
                placeholderTextColor: "#60000000"
                anchors.verticalCenterOffset: -20
                placeholderText: qsTr("Username")
            }

            TextField {
                id: password_tf
                y: 219
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: username_tf.bottom
                horizontalAlignment: Text.AlignLeft
                anchors.leftMargin: 40
                anchors.rightMargin: 40
                anchors.topMargin: 10
                placeholderText: qsTr("Password")
                echoMode: "Password"
            }

            CheckBox {
                id: checkBox
                visible: false
                text: qsTr("Remember me")
                anchors.left: password_tf.left
                anchors.top: password_tf.bottom
                transformOrigin: Item.Center
                anchors.leftMargin: 0
                anchors.topMargin: 5
            }

            Text {
                id: text1
                text: qsTr("Login")
                anchors.top: parent.top
                font.pixelSize: 24
                font.styleName: "Semibold"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20
            }

            NiceButton {
                id: login_btn
                height: 46
                text: "Login"
                anchors.left: checkBox.right
                anchors.right: password_tf.right
                anchors.top: checkBox.bottom
                state: "normal"
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.leftMargin: 10

                onClicked: {
                    if (username_tf.text === "" || password_tf.text === "") {
                        popup.text = "There is empty field!"
                        popup.open()
                        return
                    }
                    user_controller.login(username_tf.text, password_tf.text)
                }
            }

            NiceButton {
                id: register_btn
                text: "Register"
                anchors.left: checkBox.left
                anchors.right: login_btn.left
                anchors.top: checkBox.bottom
                anchors.bottom: login_btn.bottom
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.rightMargin: 20

                onClicked: {
                    stacks.replace(register_page)
                }
            }
        }
    }

    Connections {
        target: user_controller
        onLogin_response:(response, token_type_, access_token_) => {
            if (response) {
                chat_controller.open(token_type_, access_token_);
            } else {
                popup.text = "Failed to login";
                popup.open();
            }
        }
    }

    Connections {
        target: chat_controller
        onConnection_status: (online_) => {
            if (online_) {
                console.log("Before:" + globs.logged_username)
                globs.logged_username = username_tf.text
                console.log("After:" + globs.logged_username)
                stacks.replace(dashboard_page);
            }
        }
    }
}