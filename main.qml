import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 560
    height: 640
    title: "feedbacKU"

    // Create a global property to hold current user ID
    property int currentUserId: -1

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: loginPage
    }

    // Login Page Component
    Component {
        id: loginPage
        Page {
            // Background Image
            Image {
                anchors.fill: parent
                source: "qrc:/images/images/background.jpg"
                fillMode: Image.PreserveAspectCrop
            }

            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.7
            }

            ColumnLayout {
                anchors.centerIn: parent
                width: parent.width * 0.8
                spacing: 10

                Label {
                    text: "feedbacKU"
                    font.pixelSize: 38
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    color: "white"
                }

                TextField {
                    id: emailField
                    placeholderText: "Email"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    background: Rectangle {
                        radius: 5
                        color: "white"
                        opacity: 0.5
                    }
                }

                TextField {
                    id: passwordField
                    placeholderText: "Password"
                    echoMode: TextField.Password
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    background: Rectangle {
                        radius: 5
                        color: "white"
                        opacity: 0.5
                    }
                }

                Label {
                    id: loginFeedback
                    text: ""
                    font.pixelSize: 16
                    color: "red"
                    Layout.alignment: Qt.AlignHCenter
                }

                Button {
                    text: "Login"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    background: Rectangle {
                        radius: 5
                        color: "#2196F3"
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        loginFeedback.text = "";
                        var userInfo = dbManager.loginUser(emailField.text, passwordField.text);
                        if (userInfo !== null && userInfo.id !== undefined) {
                            console.log("Login successful!", userInfo);
                            // Set the current user id globally
                            currentUserId = userInfo.id;
                            stackView.push(Qt.resolvedUrl("qrc:/qml/MainFeedPage.qml"));
                        } else {
                            loginFeedback.text = "Login failed! Please check your credentials.";
                            console.log("Login failed!");
                        }
                    }
                }

                Button {
                    text: "Register"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    flat: true
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: stackView.push(registerPage)
                }

                Label {
                    text: "Kathmandu University"
                    font.pixelSize: 20
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    color: "white"
                }

                Label {
                    text: "(Dhulikhel, Kavre)"
                    font.pixelSize: 12
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    color: "white"
                }
            }
        }
    }

    // Register Page Component
    Component {
        id: registerPage
        Page {
            Image {
                anchors.fill: parent
                source: "qrc:/images/images/background.jpg"
                fillMode: Image.PreserveAspectCrop
            }
            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.7
            }
            Button {
                id: backButton
                text: "Back"
                font.pixelSize: 24
                flat: true
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: stackView.pop()
            }
            ColumnLayout {
                anchors.centerIn: parent
                width: parent.width * 0.8
                spacing: 20
                Label {
                    text: "Create Account"
                    font.pixelSize: 34
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    color: "white"
                }
                TextField {
                    id: fullNameField
                    placeholderText: "Full Name"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    background: Rectangle {
                        radius: 5
                        color: "white"
                        opacity: 0.5
                    }
                }
                TextField {
                    id: registerEmailField
                    placeholderText: "Email"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    background: Rectangle {
                        radius: 5
                        color: "white"
                        opacity: 0.5
                    }
                }
                TextField {
                    id: registerPasswordField
                    placeholderText: "Password"
                    echoMode: TextField.Password
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    background: Rectangle {
                        radius: 5
                        color: "white"
                        opacity: 0.5
                    }
                }
                TextField {
                    id: confirmPasswordField
                    placeholderText: "Confirm Password"
                    echoMode: TextField.Password
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    background: Rectangle {
                        radius: 5
                        color: "white"
                        opacity: 0.5
                    }
                }
                ComboBox {
                    id: userTypeComboBox
                    model: ["Student", "Teacher", "Parents"]
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    background: Rectangle {
                        radius: 5
                        color: "white"
                        opacity: 0.5
                    }
                }
                Label {
                    id: registrationFeedback
                    text: ""
                    font.pixelSize: 16
                    color: "red"
                    Layout.alignment: Qt.AlignHCenter
                }
                Button {
                    text: "Register"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    background: Rectangle {
                        radius: 5
                        color: "#2196F3"
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        registrationFeedback.text = "";
                        if (registerPasswordField.text !== confirmPasswordField.text) {
                            registrationFeedback.text = "Passwords do not match!";
                            return;
                        }
                        if (fullNameField.text === "" || registerEmailField.text === "" || registerPasswordField.text === "" || confirmPasswordField.text === "") {
                            registrationFeedback.text = "All fields are required!";
                            return;
                        }
                        var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
                        if (!emailPattern.test(registerEmailField.text)) {
                            registrationFeedback.text = "Please enter a valid email address!";
                            return;
                        }
                        if (dbManager.registerUser(fullNameField.text, registerEmailField.text, registerPasswordField.text)) {
                            console.log("Registration successful!");
                            stackView.pop();
                        } else {
                            registrationFeedback.text = "Registration failed! Please try again.";
                            console.log("Registration failed!");
                        }
                    }
                }
            }
        }
    }
}
