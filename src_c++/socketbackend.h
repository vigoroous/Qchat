#ifndef SOCKETBACKEND_H
#define SOCKETBACKEND_H

#include <QObject>
#include <QString>
#include <QTcpSocket>
#include <QJsonDocument>

class socketBackend : public QObject
{
    Q_OBJECT

public:
    explicit socketBackend(QObject *parent = nullptr);

public slots:
    void connectToHost(const QString &_hostName, int _port);
    void disconnectFromHost();
    void sendStringMsg(const QString &_msg);
    bool isConnected();

signals:
    void connected();
    void disconnected();
    void errorSending(const QString &errMsg);
    void msgGot(const QString &newMsg, const QString &nameSrc);

private:
    QTcpSocket _socket;
    void _connected();
    void _disconnected();
    void _onNewMsg();

};

#endif // SOCKETBACKEND_H
