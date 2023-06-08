
import QtQuick 2.15
import QtQuick.Controls 2.15

Button {

    property string name: "Username"

    id: control

    implicitWidth: Math.max(
                       buttonBackground ? buttonBackground.implicitWidth : 0,
                       textItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(
                        buttonBackground ? buttonBackground.implicitHeight : 0,
                        textItem.implicitHeight + topPadding + bottomPadding)
    leftPadding: 4
    rightPadding: 4

    text: name
    bottomInset: 0
    topInset: 0

    background: buttonBackground
    Rectangle {
        id: buttonBackground
        color: "white"
        implicitWidth: 100
        implicitHeight: 40
        opacity: 0.05
    }

    contentItem: textItem
    Row {
        Text {
            id: textItem
            text: control.text

            opacity: enabled ? 1.0 : 0.3
            color: "#fff"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            leftPadding: 10
        }
    }

    states: [
        State {
            name: "hovered"
            when: control.hovered

            PropertyChanges {
                target: buttonBackground
                color: "#add"
            }
        }
    ]
}