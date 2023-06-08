import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Column {
    id: container
    property ListModel models
    property var chat_id
    property bool is_private

    anchors.fill: parent
    anchors.bottomMargin: 0
    anchors.rightMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0
    topPadding: 0
    bottomPadding: 0

    ListView {
        id: chat_views
        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.NoSnap
        interactive: true
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: search_bar.top
            topMargin: 15
            bottomMargin: 10
            leftMargin: 10
            rightMargin: 10
        }
        clip: true
        spacing: 5

        model: models
        delegate: ChatBubble {
            username: username_
            message: message_
            timestamp: timestamp_
            is_me: is_me_
        }
    }

    Rectangle {
        id: search_bar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        height: 50
        color: "#313131"

        SearchBar {
            button_text: "SEND"
            box_color: "#313131"
            box_border_color: "white"
            anchors.fill: parent
            on_click: () => {
                var message = field_text
                console.log(message)
                // Send to room
                chat_controller.send_room_chat(container.chat_id, message)

                // Send to user
                chat_controller.send_private_chat(container.chat_id, message)

                // add the message to current model
                models.append({
                    "username_": "me",
                    "is_me_": true,
                    "message_": message,
                    "timestamp_": chat_controller.get_current_timestamp()
                });

                // Clear field
                field_text = ""
            }
        }
    }
}