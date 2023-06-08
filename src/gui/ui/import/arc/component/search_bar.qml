import QtQuick 2.15
import QtQuick.Controls 2.15

Row {
    id: row
    property string button_text: "search"
    property string box_color: "white"
    property string box_border_color: "black"
    property alias field_text: search.text
    property var on_click: null

    width: parent.width
    height: 50
    anchors.rightMargin: 5
    anchors.leftMargin: 5
    anchors.bottomMargin: 5
    anchors.topMargin: 5
    bottomPadding: 5
    topPadding: 5
    leftPadding: 10
    rightPadding: 10
    spacing: 2

    TextField {
        id: search
        width: parent.width * 4 / 5
        height: parent.height
        color: "#ddffffff"

        anchors.left: parent.left
        anchors.right: search_btn.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        horizontalAlignment: Text.AlignLeft
        placeholderText: ""
        hoverEnabled: false
        clip: true
        font.hintingPreference: Font.PreferNoHinting
        renderType: Text.QtRendering
        rightPadding: 12
        bottomPadding: 0
        topPadding: 0
        leftPadding: 12
        anchors.topMargin: 0
        anchors.rightMargin: 2
        anchors.leftMargin: 0

        background: Rectangle {
            id: bg
            color: row.box_color
            border.color: row.box_border_color
            radius: 10
        }
    }

    NiceButton {
        height: parent.height
        fill: true

        id: search_btn
        button_color: "#363636"
        width: 50
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        topInset: 0
        bottomInset: 0
        rightPadding: 0
        bottomPadding: 0
        leftPadding: 0
        topPadding: 0
        anchors.topMargin: 0
        state: "down"

        text: row.button_text

        onClicked: on_custom_clicked(search.text)
    }

    states: [
        State {
            name: "down"
            when: search.focus
            PropertyChanges {
                target: bg
                border.color: "#e91e63"
            }
        }
    ]

    function on_custom_clicked(name_) {
        if (search.text === "") {
            popup.text = "Fill the search box first";
            popup.open();
            return;
        } 

        if (row.on_click) {
            row.on_click(name_);
        }
    }
}