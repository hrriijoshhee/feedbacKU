#include "databasemanager.h"
#include <QSqlQuery>
#include <QThread>
#include <QVariant>
#include <QSqlError>
#include <QDebug>
#include <QDateTime>

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent)
{
    // Initialize the database connection here
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("feedback.db");  // Make sure the path to the database file is correct

    if (!db.open()) {
        qDebug() << "Failed to open the database!";
    } else {
        qDebug() << "Database opened successfully!";
    }
}


DatabaseManager::~DatabaseManager()
{
    if (db.isOpen()) {
        db.close();
    }
}

void DatabaseManager::initialize()
{
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("feedback_system.db");

    if (!db.open()) {
        qDebug() << "Database Error:" << db.lastError().text();
        return;
    }

    // Create 'users' table if it doesn't exist
    QSqlQuery query;
    bool success = query.exec("CREATE TABLE IF NOT EXISTS users ("
                              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                              "name TEXT NOT NULL, "
                              "email TEXT UNIQUE NOT NULL, "
                              "password TEXT NOT NULL, "
                              "username TEXT, "
                              "bio TEXT)");

    if (!success) {
        qDebug() << "Error creating users table:" << query.lastError().text();
    } else {
        qDebug() << "Table 'users' created or already exists!";
    }

    // Create 'posts' table if it doesn't exist
    success = query.exec("CREATE TABLE IF NOT EXISTS posts ("
                         "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                         "title TEXT NOT NULL, "
                         "content TEXT NOT NULL, "
                         "author TEXT, "
                         "user_id INTEGER, "
                         "created_at TEXT, "
                         "image_path TEXT, "
                         "FOREIGN KEY(user_id) REFERENCES users(id))");

    if (!success) {
        qDebug() << "Error creating posts table:" << query.lastError().text();
    } else {
        qDebug() << "Table 'posts' created or already exists!";
    }
}

bool DatabaseManager::registerUser(const QString &fullName, const QString &email, const QString &password)
{
    if (!db.isOpen()) {
        qDebug() << "Database is not open!";
        return false;
    }

    QSqlQuery checkQuery;
    checkQuery.prepare("SELECT email FROM users WHERE email = :email");
    checkQuery.bindValue(":email", email);
    if (!checkQuery.exec() || checkQuery.next()) {
        qDebug() << "Email already exists or query failed!";
        return false;
    }

    QSqlQuery query;
    query.prepare("INSERT INTO users (name, email, password) VALUES (:name, :email, :password)");
    query.bindValue(":name", fullName);
    query.bindValue(":email", email);
    query.bindValue(":password", password);

    if (query.exec()) {
        qDebug() << "User registered successfully!";
        return true;
    } else {
        qDebug() << "Registration failed:" << query.lastError().text();
        return false;
    }
}

QVariantMap DatabaseManager::loginUser(const QString &email, const QString &password)
{
    QVariantMap userInfo;
    if (!db.isOpen()) {
        qDebug() << "Database is not open!";
        return userInfo;
    }

    QSqlQuery query;
    query.prepare("SELECT * FROM users WHERE email = :email AND password = :password");
    query.bindValue(":email", email);
    query.bindValue(":password", password);

    if (query.exec() && query.next()) {
        userInfo["id"] = query.value("id").toInt();
        userInfo["fullName"] = query.value("name").toString();
        userInfo["email"] = query.value("email").toString();
        userInfo["username"] = query.value("username").toString();
        userInfo["bio"] = query.value("bio").toString();
        qDebug() << "Login successful!";
    } else {
        qDebug() << "Login failed: No matching user found.";
    }
    return userInfo;
}

void DatabaseManager::addPost(const QString &title, const QString &content, const QString &image, int userId, const QString &authorName)
{
    if (!db.isOpen()) {
        qDebug() << "Database is not open!";
        return;
    }

    int retryCount = 3;
    bool success = false;
    while (retryCount > 0) {
        // Begin transaction
        if (!db.transaction()) {
            qDebug() << "Failed to begin transaction:" << db.lastError().text();
            return;
        }

        QString userFullName = getUserNameById(userId);
        qDebug() << "User ID: " << userId;
        qDebug() << "User Full Name: " << userFullName;

        QSqlQuery query(db);
        // Use square brackets around "data" to avoid conflicts with reserved words.
        query.prepare("INSERT INTO posts (title, content, author, date, image, user_id) "
                      "VALUES (:title, :content, :author, :date, :image, :user_id)");

        // Bind the values to the named placeholders
        query.bindValue(":title", title);
        query.bindValue(":content", content);
        query.bindValue(":author", QVariant(userFullName).toString());
        query.bindValue(":date", QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));
        query.bindValue(":image", image);
        query.bindValue(":user_id", userId);

        if (query.exec()) {
            db.commit();
            qDebug() << "Post inserted successfully!";
            success = true;
            break;  // Exit the loop on success
        } else {
            qDebug() << "Failed to insert post. Error:" << query.lastError().text();
            db.rollback();
            retryCount--;
            QThread::msleep(1000);  // Wait 1 second before retrying
        }
    }

    if (!success) {
        qDebug() << "Failed to insert post after multiple attempts!";
    }
}

QVariantList DatabaseManager::getPosts() {
    QSqlQuery query("SELECT posts.id, posts.title, posts.content, posts.image, posts.user_id, posts.author "
                    "FROM posts "
                    "ORDER BY date DESC");

    QVariantList posts;

    if (!query.exec()) {
        qDebug() << "Error executing query:" << query.lastError();
        return posts;
    }

    while (query.next()) {
        QVariantMap post;
        post["id"] = query.value("id").toInt();
        post["title"] = query.value("title").toString();
        post["content"] = query.value("content").toString();
        post["imagePath"] = query.value("image").toString();
        post["userId"] = query.value("user_id").toInt();
        post["author"] = query.value("author").toString();
        posts.append(post);
    }

    return posts;
}






QVariantMap DatabaseManager::getUserInfo(int userId)
{
    QVariantMap userInfo;
    if (!db.isOpen()) {
        qDebug() << "Database is not open!";
        return userInfo;
    }

    QSqlQuery query;
    query.prepare("SELECT name, email, username, bio FROM users WHERE id = :id");
    query.bindValue(":id", userId);

    if (query.exec() && query.next()) {
        userInfo["fullName"] = query.value("name").toString();
        userInfo["email"] = query.value("email").toString();
        userInfo["username"] = query.value("username").toString();
        userInfo["bio"] = query.value("bio").toString();
    } else {
        qDebug() << "Failed to fetch user info:" << query.lastError().text();
    }
    return userInfo;
}


QVariantList DatabaseManager::getPostsByUser(int userId)
{
    QSqlQuery query;
    query.prepare("SELECT * FROM posts WHERE user_id = :userId ORDER BY created_at DESC");
    query.bindValue(":userId", userId);
    QVariantList posts;

    if (query.exec()) {
        while (query.next()) {
            QVariantMap post;
            post["id"] = query.value("id").toInt();
            post["title"] = query.value("title").toString();
            post["content"] = query.value("content").toString();
            post["imagePath"] = query.value("image_path").toString();
            post["userId"] = query.value("user_id").toInt();
            post["createdAt"] = query.value("created_at").toString();
            posts.append(post);
        }
    } else {
        qDebug() << "Error fetching posts by user: " << query.lastError();
    }

    return posts;
}

bool DatabaseManager::deletePost(int postId)
{
    QSqlQuery query;
    query.prepare("DELETE FROM posts WHERE id = :id");
    query.bindValue(":id", postId);
    if (!query.exec()) {
        qDebug() << "Failed to delete post:" << query.lastError().text();
        return false;
    }
    return true;
}

void DatabaseManager::setCurrentUserId(int userId)
{
    currentUserId = userId;
}

// Inside DatabaseManager.cpp
bool DatabaseManager::isOpen() const {
    return db.isOpen();  // Assuming db is your QSqlDatabase object
}
QString DatabaseManager::getUserNameById(int userId) {
    QSqlQuery query;
    query.prepare("SELECT name FROM users WHERE id = :id");
    query.bindValue(":id", userId);

    if (query.exec() && query.next()) {
        return query.value(0).toString(); // Return the name
    } else {
        qDebug() << "Failed to fetch user name. Error:" << query.lastError().text();
        return ""; // Return empty if not found
    }
}

