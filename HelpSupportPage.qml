import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Page {
    id: helpSupportPage
    anchors.fill: parent
    title: "Help & Support"

    // Background Image for Popup
    Item {
        width: parent.width
        height: parent.height
        Image {
            source: "qrc:/images/images/helpsupport.jpg" // Change to your image path
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }

        // Semi-transparent Background on top of the Image
        Rectangle {
            width: parent.width
            height: parent.height
            color: Qt.rgba(255, 255, 255, 0.5) // Semi-transparent background
            radius: 0
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Title
        Label {
            text: "FAQs"
            font.bold: true
            font.pixelSize: 34
            Layout.alignment: Qt.AlignHCenter
        }

        // FAQ Section
        GroupBox {
            //title: "Frequently Asked Questions"
            //Layout.fillWidth: true
            ColumnLayout {
                spacing: 10

                Label { text: "Q: How do I submit feedback?" }
                Label { text: "A: Click the ➕ button at the bottom and fill out the form." }

                Label { text: "Q: How do I edit my profile?" }
                Label { text: "A: Go to the Profile Page and click 'Edit Profile'." }

                Label { text: "Q: How do I reset my password?" }
                Label { text: "A: Contact support or use the Forgot Password option in Login." }
            }
        }

        // Contact Support Button
        Button {
            text: "Contact Support"
            Layout.fillWidth: true
            onClicked: Qt.openUrlExternally("https://www.instagram.com/elonrmuskk?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==")
        }

        // Report an Issue Button
        Button {
            text: "Report an Issue"
            Layout.fillWidth: true
            onClicked: Qt.openUrlExternally("https://www.instagram.com/sumangiri109?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==")
        }

        // Back Button
        Button {
            text: "Back"
            Layout.alignment: Qt.AlignHCenter
            onClicked: stackView.pop()
        }
    }
}
