import QtQuick 2.15
import QtQuick.Controls 2.15

import QtQuick 6.4
import QtQuick.Controls 6.4
import QtQuick.Controls.Material
import Qt5Compat.GraphicalEffects
import arc.controller
import arc.component

Rectangle {

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
        id: rectangle1
        width: 400
        height: 400
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Material.elevation: 20
        Rectangle {
            anchors.fill: parent

            TextField {
                id: username_tf
                y: 185
                text: ""
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: text1.bottom
                anchors.topMargin: 30
                anchors.leftMargin: 40
                anchors.rightMargin: 40
                placeholderTextColor: "#60000000"
                placeholderText: qsTr("Username")
            }

            TextField {
                id: password_tf
                y: 219
                anchors.left: username_tf.left
                anchors.right: username_tf.right
                anchors.top: username_tf.bottom
                horizontalAlignment: Text.AlignLeft
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 10
                placeholderText: qsTr("Password")
                echoMode: "Password"
            }

            TextField {
                id: password_confirm_tf
                x: -4
                anchors.left: password_tf.left
                anchors.right: password_tf.right
                anchors.top: password_tf.bottom
                horizontalAlignment: Text.AlignLeft
                placeholderText: qsTr("Confirm Password")
                anchors.rightMargin: 0
                echoMode: "Password"
                anchors.topMargin: 10
                anchors.leftMargin: 0
            }

            CheckBox {
                id: checkBox
                text: qsTr("Agree with Our Terms & Condition")
                anchors.left: password_confirm_tf.left
                anchors.top: password_confirm_tf.bottom
                transformOrigin: Item.Center
                anchors.leftMargin: 0
                anchors.topMargin: 5
            }

            Text {
                id: text1
                color: "#1e1e1e"
                text: qsTr("Register")
                anchors.top: parent.top
                font.pixelSize: 24
                font.styleName: "Semibold"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20
            }

            NiceButton {
                id: register_btn
                text: "Register"
                anchors.left: login_btn.right
                anchors.right: password_confirm_tf.right
                anchors.top: checkBox.bottom
                anchors.bottomMargin: 0
                anchors.leftMargin: 10
                anchors.topMargin: 10
                anchors.rightMargin: 0

                onClicked: {

                    if (username_tf.text === "" || password_tf.text === "" || password_confirm_tf.text === "") {
                        popup.text = "Field should not be empty"
                    } else if (password_confirm_tf.text !== password_tf.text) {
                        popup.text = "Password should be the same"
                    } else if (!checkBox.checked) {
                        popup.text = "You should agree with our Terms and Condition to registering your account"
                    } else {
                        user_controller.signup(username_tf.text, password_tf.text);
                        return
                    }
                    popup.open()
                }
            }

            NiceButton {
                id: login_btn
                text: "Login"
                anchors.left: checkBox.left
                anchors.right: login_btn.left
                anchors.top: checkBox.bottom
                anchors.bottom: login_btn.bottom
                anchors.topMargin: 10
                anchors.rightMargin: 20
                anchors.leftMargin: 0

                onClicked: {
                    stacks.replace(login_page)
                }

                anchors.bottomMargin: 0
            }
        }
    }

    Connections {
    target: user_controller
    onRegister_response:(response) => {
        if (response) {
            stacks.replace(login_page)
        } else {
            popup.text = "Register failed!";
            popup.open();
        }
    }
}
}