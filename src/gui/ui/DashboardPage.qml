import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import arc.component
import arc.controller

Rectangle {
    id: rectangle

    anchors.fill: parent
    color: "#313131"

    RowLayout {
        id: layout
        anchors.fill: parent
        spacing: 0

        Column {
            id: column
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.minimumWidth: 200
            Layout.maximumWidth: 350
            Layout.fillHeight: true

            SearchBar {
                id: search_bar
                width: parent.width
                box_color: "#313131"
                box_border_color: "white"
                height: 40

                on_click: (name_) => {
                    chat_room.visible = false
                    chat_controller.get_users(name_);
                }
            }

            ListView {
                id: contact_view
                anchors.top: search_bar.bottom
                anchors.bottom: parent.bottom
                boundsBehavior: Flickable.StopAtBounds
                interactive: true
                clip: true
                width: parent.width

                model: contact_original_model
                delegate: Contact {
                    width: contact_view.width
                    name: name_

                    onClicked: {
                        var change_model = false
                        if (contact_view.model == contact_search_model) {
                            // Append to original one
                            var data = {"id_": id_, "name_": name_, "is_private": is_private}
                            contact_original_model.append(data)
                            change_model = true
                        }
                        var model = chat_model_container.get(id_)
                        if (model == null) {
                            // Create new model
                            chat_model_container.add(id_)
                            model = chat_model_container.get(id_)
                        }
                        chat_room.models = model
                        chat_room.chat_id = id_
                        chat_room.is_private = is_private

                        chat_room.visible = true

                        console.log("Change Chat ID: " + id_)
                        // Change to original model
                        if (change_model) {
                            contact_view.model = contact_original_model
                        }
                    }
                }
            }
        }

        Rectangle {
            color: "#282828"
            Layout.minimumWidth: 400
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListModel {
                id: chat_model
            }

            ChatRoom {
                id: chat_room
                visible:false
                anchors.fill: parent
                clip: false
                models: chat_model
            }
        }
    }

    Connections {
        target: chat_controller
        onNew_list_users: (users_) => {
            contact_search_model.clear()
            for (const user of users_) {
                var data = {"id_": user.id, "name_": user.name, "is_private": true}
                contact_search_model.append(data)
            }

            contact_view.model = contact_search_model
        }

        onNew_private_chat: (message_) => {

            // Check if this one is the same user id
            // TODO: Same User ID doesn't know the receiver so it cant append it to the receiver model
            var is_me = message_.sender_name === globs.logged_username
            var user_id = message_.sender_id

            var model = chat_model_container.get(message_.sender_id)
            if (model == null) {
                // Create new model
                chat_model_container.add(message_.sender_id)
                model = chat_model_container.get(message_.sender_id)

                contact_original_model.append({"id_": message_.sender_id, "name_": message_.sender_name, "is_private_": true})
            }

            model.append({
                "username_": message_.sender_name,
                "message_": message_.message,
                "timestamp_": message_.time,
                "is_me_": false
            })
        }

        onNew_room_chat: (message_) => {
            var model = chat_model_container.get(message_.room_id)
            if (model == null) {
                console.log("no model")
                // Create new model
                chat_model_container.add(message_.room_id)
                model = chat_model_container.get(message_.room_id)

                // Add into contact_view.model
                contact_view.model = contact_original_model
                contact_original_model.append({"id_": message_.room_id, "name_": message_.room_id, "is_private_": false})
            }
            // Check if this one is the same user id
            var is_me = message_.sender_name === globs.logged_username

            model.append({
                "username_": message_.sender_name,
                "message_": message_.message,
                "timestamp_": message_.time,
                "is_me_": is_me
            })
        }
    }
}