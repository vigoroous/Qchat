#ifndef SOCKETBACKEND_H
#define SOCKETBACKEND_H

#include <QObject>
#include <QString>
#include <QTcpSocket>

class socketBackend : public QObject
{
    Q_OBJECT

public:
    explicit socketBackend(QObject *parent = nullptr);

public slots:
    void connectToHost(const QString &_hostName, int _port);
    void sendStringMsg(const QString &_msg);
    bool isConnected();

signals:
    void connected();
    void disconnected();
    void errorSending(const QString &errMsg);

private:
    QTcpSocket _socket;
    void _connected();
    void _disconnected();

};

#endif // SOCKETBACKEND_H
