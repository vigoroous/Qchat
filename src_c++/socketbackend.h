#ifndef SOCKETBACKEND_H
#define SOCKETBACKEND_H

#include <QObject>
#include <QString>
#include <QTcpSocket>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>

class socketBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool choosenServer READ choosenServer)
    Q_PROPERTY(bool isConnected READ isConnected)

public:
    explicit socketBackend(QObject *parent = nullptr);

public slots:
    void connectToHost(const QString &_hostName, int _port, const QString &_name);
    void connectToServer(const int num);
    void disconnectFromHost();
    void sendStringMsg(const QString &_msg);
    //void changeServer(int servDesc);

signals:
    void serversGot(const QJsonArray &serversArr);
    void serverChanged();
    void connectedMessages();
    void disconnected();
    void errorSending(const QString &errMsg);
    void msgGot(const QString &newMsg, const QString &nameSrc);

private:
    QTcpSocket _socket;
    void _connected();
    void _disconnected();
    void _changed_server();
    void _onNewMsg();
    bool choosenServer();
    bool isConnected();
    int _choosen_server;

};

#endif // SOCKETBACKEND_H
