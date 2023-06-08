
import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    property bool fill: false
    property string button_color: "#e91e63"
    id: control

    implicitWidth: Math.max(
                       buttonBackground ? buttonBackground.implicitWidth : 0,
                       textItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(
                        buttonBackground ? buttonBackground.implicitHeight : 0,
                        textItem.implicitHeight + topPadding + bottomPadding)

    text: "Button"
    bottomInset: 0
    topInset: 0
    rightPadding: 0
    bottomPadding: 0
    leftPadding: 0
    topPadding: 0

    background: buttonBackground
    Rectangle {
        id: buttonBackground
        color: parent.fill ? control.button_color : "#00000000"
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        radius: 5
        border.color: parent.fill ? "#ffffffff" : control.button_color
        border.width: 1.5
    }

    contentItem: textItem
    Text {
        id: textItem
        text: control.text

        opacity: enabled ? 1.0 : 0.3
        color: parent.fill ? "#ffffffff" : "#111"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    hoverEnabled: false
    states: [
        State {
            name: "down"
            when: control.down
            PropertyChanges {
                target: textItem
                color: parent.fill ? "#000" : "#ffffffff"
            }

            PropertyChanges {
                target: buttonBackground
                color: parent.fill ? "#ffffffff" : control.button_color
                border.color: parent.fill ? control.button_color : "#00000000"
            }
        }
    ]
}