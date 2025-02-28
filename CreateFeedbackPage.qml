import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Page {
    id: feedbackPage
    anchors.fill: parent

    // Background Image
    Image {
        source: "qrc:/images/images/background1.jpg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        z: -1
    }

    // Semi-transparent Content Background
    Rectangle {
        id: contentBackground
        width: parent.width * 0.8
        height: parent.height * 0.8
        anchors.centerIn: parent
        radius: 15
        color: Qt.rgba(255, 255, 255, 0.6)
    }

    // Title at the top-center
    Label {
        text: "Feedback"
        font.bold: true
        font.pixelSize: 36
        font.family: "Courier"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        color: "lightgray"
    }

    ColumnLayout {
        anchors.fill: contentBackground
        anchors.margins: 20
        spacing: 15

        // Input Fields for Title and Content
        TextField { id: titleField; placeholderText: "Enter title..."; Layout.fillWidth: true }
        TextArea { id: contentField; placeholderText: "Enter your feedback..."; Layout.fillWidth: true; Layout.fillHeight: true }

        // Image Attachment
        FileDialog {
            id: imagePicker
            title: "Select an image"
            fileMode: FileDialog.OpenFile
            nameFilters: ["Images (*.png *.jpg *.jpeg)"]
            onAccepted: { imagePreview.source = selectedFile }
        }
        Button { text: "Attach Image"; onClicked: imagePicker.open() }

        // Image Preview
        Rectangle {
            width: 150; height: 150; color: "#ddd"; border.color: "#aaa"; border.width: 1; visible: imagePreview.source !== ""
            Image { id: imagePreview; width: parent.width; height: parent.height; fillMode: Image.PreserveAspectFit; sourceSize.width: 150; sourceSize.height: 150; anchors.centerIn: parent }
        }

        // Submit & Preview Buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 20
            Button {
                text: "Preview"
                Layout.fillWidth: true
                onClicked: previewDialog.open()
            }
            Button {
                text: "Submit"
                Layout.fillWidth: true
                onClicked: {
                    if (titleField.text !== "" && contentField.text !== "") {
                        // Add debug line to check the userFullName before passing it to addPost
                        console.log("User Full Name: " + userFullName);

                        // Pass the data to the C++ function to add the post in the database
                        dbManager.addPost(titleField.text, contentField.text, imagePreview.source, currentUserId, userFullName);

                        // Clear the input fields
                        titleField.text = "";
                        contentField.text = "";
                        imagePreview.source = "";  // Clear the image preview

                        // Open the success popup
                        submitPopup.open();
                    } else {
                        console.log("Title and content must not be empty!");
                    }
                }
            }



        }
    }

    // Back Button
    Button {
        text: "Back"
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 10
        onClicked: stackView.push(Qt.resolvedUrl("qrc:/qml/MainFeedPage.qml"))
    }

    // Submit Success Popup
    Dialog {
        id: submitPopup
        title: "Feedback Submitted"
        width: parent.width * 0.6
        height: parent.height * 0.4
        anchors.centerIn: parent
        Item {
            width: parent.width
            height: parent.height
            Image {
                source: "/images/submitted.jpg"
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
            }
            Rectangle {
                width: parent.width
                height: parent.height
                color: Qt.rgba(255, 255, 255, 0.3)
                radius: 0
            }
        }
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10
            Label {
                text: "Feedback Submitted"
                font.bold: true
                font.pixelSize: 22
                Layout.alignment: Qt.AlignHCenter
                color: "#222"
            }
            Label {
                text: "Thank you for your feedback!"
                font.pixelSize: 18
                Layout.alignment: Qt.AlignHCenter
                color: "#444"
            }
            Item { height: 10 }
            RowLayout {
                Layout.fillWidth: true
                spacing: 20
                anchors.topMargin: 30
                Button {
                    text: "Return to Home"
                    onClicked: {
                        stackView.pop();
                        submitPopup.close();
                    }
                }
                Button {
                    text: "Submit Another"
                    onClicked: {
                        titleField.text = "";
                        contentField.text = "";
                        imagePreview.source = "";
                        submitPopup.close();
                    }
                }
            }
        }
    }

    // Preview Dialog
    Dialog {
        id: previewDialog
        title: "Preview Feedback"
        width: parent.width * 0.8
        height: parent.height * 0.75
        anchors.centerIn: parent
        Item {
            width: parent.width
            height: parent.height
            Image {
                source: "qrc:/images/feedback.jpg"
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
            }
            Rectangle {
                width: parent.width
                height: parent.height
                color: Qt.rgba(255, 255, 255, 0.4)
                radius: 0
            }
        }
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            Label { text: "Title: " + titleField.text; font.bold: true; font.pixelSize: 18; color: "#222" }
            Label { text: "Content: " + contentField.text; font.pixelSize: 16; color: "#222" }
            Rectangle {
                width: 120; height: 120; color: "#ddd"; border.color: "#aaa"; border.width: 1; visible: previewImage.source !== ""
                Image {
                    id: previewImage
                    source: imagePreview.source
                    width: parent.width
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: 120
                    sourceSize.height: 120
                    anchors.centerIn: parent
                }
            }
        }
    }
}
