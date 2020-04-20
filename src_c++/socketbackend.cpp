#include "socketbackend.h"

socketBackend::socketBackend(QObject *parent) : QObject(parent)
{
    QObject::connect(&_socket, &QTcpSocket::connected, this, &socketBackend::_connected);
    QObject::connect(&_socket, &QTcpSocket::disconnected, this, &socketBackend::_disconnected);
}

void socketBackend::connectToHost(const QString &_hostName, int _port)
{
    _socket.connectToHost(_hostName, _port);
}

void socketBackend::disconnectFromHost()
{
    _socket.disconnectFromHost();
}

void socketBackend::sendStringMsg(const QString &_msg)
{
    if (_socket.state() != QAbstractSocket::ConnectedState) {
        qDebug("error appeared...\n");
        emit errorSending("Socket is not connected\n");
        return;
    }
    QByteArray _msgAsBytes = _msg.toLocal8Bit();
    _socket.write(_msgAsBytes, _msgAsBytes.size());
}

bool socketBackend::isConnected()
{
    return _socket.state() == QAbstractSocket::ConnectedState;
}

void socketBackend::_connected()
{
    qDebug("connected...\n");
    QObject::connect(&_socket, &QTcpSocket::readyRead, this, &socketBackend::_onNewMsg);
    qDebug("connected signal onReadyRead...\n");
    emit connected();
}

void socketBackend::_disconnected()
{
    qDebug("disconnected...\n");
    QObject::disconnect(&_socket, &QTcpSocket::readyRead, this, &socketBackend::_onNewMsg);
    qDebug("disconnected signal onReadyRead...\n");
    emit disconnected();
}

void socketBackend::_onNewMsg()
{
    QByteArray readBuf = _socket.read(_socket.bytesAvailable());
    //parse JSON
    QJsonDocument jsonData = QJsonDocument::fromJson(readBuf);
    if (jsonData.isNull()) {
        qWarning("Failed to parse json msg");
        return;
    }
    emit msgGot(jsonData["data"].toString(), jsonData["name"].toString());
}
