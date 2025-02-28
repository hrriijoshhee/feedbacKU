import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform 1.0


Page {
    id: profilePage
    anchors.fill: parent

    // Background Image
    Image {
        source: "qrc:/images/images/background1.jpg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        z: -1
    }

    // Back Button
        Button {
            text: "Back"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 10
            onClicked: {
                stackView.pop()  // Go back to the previous page
            }
        }

    // Title at the top-center of the page
    Label {
        text: "MyProfile"
        font.bold: true
        font.pixelSize: 36
        font.family: "Courier"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        color: "lightgray"
    }

    ColumnLayout {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 12
        anchors.margins: 10
        width: parent.width * 0.85
        anchors.topMargin: 50

        // Profile Picture
        Rectangle {
            width: 140
            height: 140
            radius: 70
            color: "#ddd"
            border.color: "#aaa"
            border.width: 1
            Layout.alignment: Qt.AlignHCenter

            Image {
                id: profilePic
                source: profileData.profilePic
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectCrop
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: if (editMode) imagePicker.open()
            }
        }

        // Post Count
        Label {
            id: postCount
            text: "Posts: " + postModel.count
            font.bold: true
            font.pixelSize: 18
            Layout.alignment: Qt.AlignHCenter
        }

        // Username & Bio (Editable)
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            width: parent.width * 0.75

            TextField {
                id: username
                text: profileData.username
                font.bold: true
                font.pixelSize: 20
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * 0.75
                horizontalAlignment: TextField.AlignHCenter
                readOnly: !editMode
                visible: editMode
            }
            Label {
                text: username.text
                font.bold: true
                font.pixelSize: 20
                Layout.alignment: Qt.AlignHCenter
                visible: !editMode
            }
            TextArea {
                id: bio
                text: profileData.bio
                font.pixelSize: 16
                wrapMode: TextArea.Wrap
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: TextArea.AlignHCenter
                readOnly: !editMode
                visible: editMode
            }
            Label {
                text: bio.text
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                visible: !editMode
            }
        }

        // Edit & Save/Cancel Buttons
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            Button {
                text: editMode ? "Save" : "Edit Profile"
                font.pixelSize: 16
                padding: 8
                implicitWidth: 90
                implicitHeight: 30
                onClicked: {
                    if (editMode) {
                        console.log("Profile Updated:", username.text, bio.text);
                        databaseManager.updateUserProfile(userId, username.text, bio.text);
                        profileData.username = username.text;
                        profileData.bio = bio.text;
                    }
                    editMode = !editMode;
                }
            }
            Button {
                text: "Cancel"
                font.pixelSize: 16
                padding: 8
                implicitWidth: 80
                implicitHeight: 30
                visible: editMode
                onClicked: editMode = false
            }
        }

        // Divider Line
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#ddd"
            Layout.topMargin: 12
            Layout.bottomMargin: 20
        }

        // Post Grid View
        GridView {
            id: gridView
            model: postModel
            visible: true
            cellWidth: parent.width / 3 - 4
            cellHeight: cellWidth * 1.1
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.35
            Layout.bottomMargin: 10

            delegate: Rectangle {
                width: gridView.cellWidth - 8
                height: gridView.cellHeight - 8
                color: "#eee"
                border.color: "#bbb"
                border.width: 1
                radius: 3

                Image {
                    anchors.fill: parent
                    anchors.margins: 2
                    source: modelData
                    fillMode: Image.PreserveAspectCrop
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        popupImage.source = modelData;
                        postPopup.open();
                    }
                }
            }
        }
    }

    // Post Popup
    Popup {
        id: postPopup
        width: parent.width * 0.75
        height: parent.height * 0.75
        modal: true
        dim: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        anchors.centerIn: parent

        Rectangle {
            width: parent.width
            height: parent.height
            color: "#ffffff"
            border.color: "#aaa"
            border.width: 1
            radius: 8

            ColumnLayout {
                anchors.fill: parent
                spacing: 8
                anchors.margins: 12

                Image {
                    id: popupImage
                    width: parent.width * 0.93
                    height: parent.height * 0.83
                    fillMode: Image.PreserveAspectFit
                    Layout.alignment: Qt.AlignHCenter
                }

                Button {
                    text: "Back"
                    font.pixelSize: 16
                    padding: 8
                    implicitWidth: 100
                    implicitHeight: 40
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.margins: 12
                    onClicked: postPopup.close()
                }
            }
        }
    }

    // Image Picker for Profile Picture
    FileDialog {
        id: imagePicker
        title: "Select a profile picture"
        fileMode: FileDialog.OpenFile
        nameFilters: ["Images (*.png *.jpg *.jpeg)"]
        onAccepted: { profilePic.source = selectedFile }
    }

    // Editable Mode and Profile Data
    property bool editMode: false
    property int userId: 1  // Example userId; should be set dynamically in your app
    property var profileData: {
        "username": "your_username",
        "bio": "This is my bio. Welcome to my profile!",
        "profilePic": "images/user_placeholder.png"
    }

    // Sample Post Model (Dynamically populated)
    ListModel {
        id: postModel
        ListElement { modelData: "images/post1.jpg" }
        ListElement { modelData: "images/post2.jpg" }
        ListElement { modelData: "images/post3.jpg" }
    }

    // Fetch posts for user profile on load
    Component.onCompleted: {
        databaseManager.getPosts(userId);  // Fetch posts for this user
    }

    // Update the post model when posts are fetched
    Connections {
        target: databaseManager
        onPostsFetched: {
            postModel.clear();
            for (var i = 0; i < posts.length; i++) {
                postModel.append({ modelData: posts[i].image });
            }
            postCount.text = "Posts: " + postModel.count;
        }
    }
}
