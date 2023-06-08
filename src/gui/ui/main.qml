import QtQuick
import QtQuick.Controls
import arc.controller
import arc.component

Window {
    width: 500
    height: 500
    minimumWidth: 1080
    minimumHeight: 600

    visible: true
    title: "UntitledProject"

    StackView {
        id: stacks
        anchors.fill: parent
        initialItem: login_page
    }

    Item {
        id: globs
        property string logged_username: ""
    }

    Component {
        id: login_page
        LoginPage {}
    }

    Component {
        id: register_page
        RegisterPage {}
    }

    Component {
        id: dashboard_page
        DashboardPage {
        }
    }

    UserController {
        id: user_controller
        uri: rest_url
    }

    ChatController {
        id: chat_controller
        uri: ws_url
    }

    ListModel {
        id: contact_original_model

        ListElement {
            id_: "general"
            name_: "general"
            is_private: false
        }
    }

    ListModel {
        id: contact_search_model
    }

    Component {
        id: dummy_model
        ListModel {}
    }

    Item {
        id: chat_model_container

        property var chat_models: {
            "general": dummy_model.createObject(parent) }

        function add(user_id) {
            chat_models[user_id] = dummy_model.createObject(parent);
        }

        function get(user_id) {
            return chat_models[user_id]
        }
    }

    Popup {
        property var text

        id: popup
        width: parent.width / 3
        height: 50
        y: 10
        x: (parent.width / 2) - (width / 2)
        text: ""

        modal: false
        focus: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        contentItem: Text {
            anchors.centerIn: parent
            id: content
            text: popup.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}