#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QVariantMap>
#include <QVariantList>

class DatabaseManager : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseManager(QObject *parent = nullptr);  // Keep only this constructor
    ~DatabaseManager();

    bool isOpen() const;
    Q_INVOKABLE void initialize();
    Q_INVOKABLE bool registerUser(const QString &fullName, const QString &email, const QString &password);
    Q_INVOKABLE QVariantMap loginUser(const QString &email, const QString &password);
    Q_INVOKABLE QVariantMap getUserInfo(int userId);
    Q_INVOKABLE void addPost(const QString &title, const QString &content, const QString &image, int userId, const QString &authorName);  // Removed category
    Q_INVOKABLE QVariantList getPosts();     // Fetch all posts (no category)
    Q_INVOKABLE QVariantList getPostsByUser(int userId);
    Q_INVOKABLE bool deletePost(int postId);
    QString getUserNameById(int userId);
    Q_INVOKABLE void setCurrentUserId(int userId);

signals:
    void postsFetched(const QVariantList &posts);

private:
    QSqlDatabase db;
    int currentUserId;  // Add the current user ID as a private member variable
};

#endif // DATABASEMANAGER_H
