import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import App.Database 1.0

Page {
    id: feedPage
    anchors.fill: parent
    property int currentUserId: 1  // Set dynamically after login
    property var postModel: ListModel {}

    // Background Image
    Rectangle {
        anchors.fill: parent
        Image {
            source: "qrc:/images/images/background1.jpg"
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.topMargin: 20

        Label {
            text: "Feedback"
            font.bold: true
            font.pixelSize: 36
            font.family: "Courier"
            color: "black"
            Layout.alignment: Qt.AlignHCenter
        }

        ListView {
            id: feedList
            width: parent.width * 0.9
            height: parent.height * 0.7
            spacing: 20
            anchors.centerIn: parent
            model: postModel

            delegate: Item {
                width: feedList.width
                height: model.imagePath ? 250 : 180

                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "lightgreen"
                    border.color: "#ccc"
                    border.width: 1
                    radius: 10

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15

                        Label {
                            text: model.title
                            font.bold: true
                            font.pixelSize: 18
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: model.content
                            font.pixelSize: 14
                            elide: Text.ElideRight
                            width: parent.width * 0.9
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: "By " + model.author
                            font.pixelSize: 12
                            color: "gray"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Image {
                            source: model.imagePath
                            width: parent.width * 0.9
                            height: 100
                            fillMode: Image.PreserveAspectFit
                            visible: model.imagePath !== ""
                        }

                        Button {
                            text: "Delete"
                            Layout.alignment: Qt.AlignHCenter
                            background: Rectangle {
                                color: "red"
                                radius: 5
                            }
                            enabled: model.userId === currentUserId
                            onClicked: {
                                console.log("Deleting Post with ID:", model.id);
                                dbManager.deletePost(model.id);
                                refreshFeed();
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 60
        color: "lightgreen"
        border.color: "lightgreen"
        border.width: 1
        anchors.bottom: parent.bottom

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 20

            ToolButton {
                text: "🏠"
                Layout.fillWidth: true
            }
            ToolButton {
                text: "➕"
                Layout.fillWidth: true
                onClicked: stackView.push(Qt.resolvedUrl("CreateFeedbackPage.qml"))
            }
            ToolButton {
                text: "👤"
                Layout.fillWidth: true
                onClicked: stackView.push(Qt.resolvedUrl("ProfilePage.qml"))
            }
            ToolButton {
                id: menuButton
                text: "☰"
                Layout.fillWidth: true
                onClicked: optionsMenu.popup()
            }
        }
    }

    Menu {
        id: optionsMenu
        y: parent.height - 280
        x: parent.width - width - 10
        width: 200

        MenuItem {
            text: "Settings"
            onTriggered: stackView.push(Qt.resolvedUrl("SettingsPage.qml"))
        }
        MenuItem {
            text: "Help & Support"
            onTriggered: stackView.push(Qt.resolvedUrl("HelpSupportPage.qml"))
        }
        MenuSeparator {}
        MenuItem {
            text: "Logout"
            onTriggered: logoutDialog.open()
        }
    }

    Dialog {
        id: logoutDialog
        title: "Confirm Logout"
        width: parent.width * 0.4
        height: parent.height * 0.3
        anchors.centerIn: parent
        standardButtons: Dialog.Yes | Dialog.No
        Label {
            text: "Are you sure you want to logout?"
        }
        onAccepted: stackView.replace(Qt.resolvedUrl("main.qml"))
    }

    function refreshFeed() {
        console.log("Refreshing Feed");

        // Fetch posts from the database
        var posts = dbManager.getPosts();

        if (posts.length === 0) {
            console.log("No posts available.");
        } else {
            console.log("Fetched posts: " + posts.length);
        }

        // Clear the existing posts in the model
        postModel.clear();

        // Append the updated posts
        for (var i = 0; i < posts.length; i++) {
            postModel.append(posts[i]);
        }
    }


    Component.onCompleted: {
        refreshFeed();  // Call refreshFeed when the page is completed
    }

}
