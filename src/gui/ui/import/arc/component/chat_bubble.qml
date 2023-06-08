
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material

Rectangle {
    id: container
    property string username: ""
    property string message: ""
    property string timestamp: "00:00"
    property int min_width: 200
    property int min_height: 56
    property bool is_me: false

    radius: 10
    clip: true
    color: is_me ? "#454545" : "#1f1f1f"
    width: {
        return message_text.width + 8 <= min_width ? min_width : message_text.width + 20
    }
    height: min_height

    anchors.right: is_me ? parent.right : null
    anchors.left: is_me ? null : parent.left

    Text {
        visible: container.is_me ? false : true
        id: name
        color: "#ffffff"
        text: container.username === "" ? "Username" : container.username
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 0
        anchors.leftMargin: 8
        anchors.topMargin: 0
        font.bold: true
        font.pointSize: 12
    }

    Text {
        id: message_text
        text: container.message === "" ? "message" : container.message
        color: "#fff"
        anchors.left: parent.left
        anchors.top: name.bottom
        anchors.leftMargin: 8
        anchors.topMargin: 2
    }

    Text {
        id: timestamp
        text: container.timestamp
        color: "#fff"
        anchors.right: parent.right
        anchors.top: message_text.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        anchors.rightMargin: 5
        anchors.leftMargin: 5
    }
}
