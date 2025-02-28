import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Page {
    id: settingsPage
    anchors.fill: parent
    title: "Settings"

    // Background Image for Popup
    Item {
        width: parent.width
        height: parent.height
        Image {
            source: "qrc:/images/images/setting.jpg" // Change to your image path
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }

        // Semi-transparent Background on top of the Image
        Rectangle {
            width: parent.width
            height: parent.height
            color: Qt.rgba(255, 255, 255, 0.3) // Semi-transparent background
            radius: 0
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Title
        Label {
            text: "Settings"
            font.bold: true
            font.pixelSize: 24
            Layout.alignment: Qt.AlignHCenter
        }

        // Dark Mode Toggle
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Dark Mode"; Layout.fillWidth: true }
            Switch {
                id: darkModeSwitch
                onCheckedChanged: {
                    if (checked) {
                        settingsPage.color = "#222"
                    } else {
                        settingsPage.color = "#fff"
                    }
                }
            }
        }

        // Notifications Toggle
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Enable Notifications"; Layout.fillWidth: true }
            Switch {
                id: notificationSwitch
            }
        }

        // Theme Selection
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Select Theme"; Layout.fillWidth: true }
            ComboBox {
                model: ["Light", "Dark", "Blue", "Green"]
            }
        }

        // Back Button
        Button {
            text: "Back"
            Layout.alignment: Qt.AlignHCenter
            onClicked: stackView.push(Qt.resolvedUrl("qrc:/qml/MainFeedPage.qml"));
        }
    }
}
