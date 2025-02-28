#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QCoreApplication>
#include "databasemanager.h"

int main(int argc, char *argv[])
{
    // High DPI scaling and force software OpenGL
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseSoftwareOpenGL);

    QGuiApplication app(argc, argv);
    qmlRegisterType<DatabaseManager>("App.Database", 1, 0, "DatabaseManager");

    // Force Windows platform plugin (if needed)
    qputenv("QT_QPA_PLATFORM", "windows");

    QQmlApplicationEngine engine;

    // Create and initialize the DatabaseManager
    DatabaseManager dbManager;
    dbManager.initialize();

    // For testing, we hardcode the current user id as 1.
    int currentUserId = 1;

    // Retrieve the user's full name using the DatabaseManager.
    QString userFullName = "Default User";
    QSqlQuery query;
    query.prepare("SELECT name FROM users WHERE id = :user_id");
    query.bindValue(":user_id", currentUserId);
    if (query.exec() && query.next()) {
        userFullName = query.value("name").toString();
        qDebug() << "User name retrieved:" << userFullName;
    } else {
        qDebug() << "Failed to retrieve logged-in user's name!";
        qDebug() << "SQL Error:" << query.lastError().text();
    }

    // Expose the DatabaseManager, currentUserId, and userFullName to QML
    engine.rootContext()->setContextProperty("dbManager", &dbManager);
    engine.rootContext()->setContextProperty("currentUserId", currentUserId);
    engine.rootContext()->setContextProperty("userFullName", userFullName);

    // Load main QML file
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
