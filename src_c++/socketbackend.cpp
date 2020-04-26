#include "socketbackend.h"

socketBackend::socketBackend(QObject *parent) : QObject(parent)
{
    QObject::connect(&_socket, &QTcpSocket::disconnected, this, &socketBackend::_disconnected);
}

void socketBackend::connectToHost(const QString &_hostName, int _port, const QString &_name)
{
    _socket.connectToHost(_hostName, _port);
    //add fetching servers synchorosly in thread
    //and then QObjet connect
    if (!_socket.waitForConnected()) {
        qWarning("Socket is not connected");
        _socket.error();
        return;
    }

    QByteArray _msgAsBytes = _name.toLocal8Bit();
    _socket.write(_msgAsBytes, _msgAsBytes.size());

    if (!_socket.waitForReadyRead()) {
        qWarning("Socket did not send data");
        return;
    }

    QByteArray readBuf = _socket.read(_socket.bytesAvailable());
    QJsonDocument readMsg = QJsonDocument::fromJson(readBuf);
    if (!readMsg.isArray()){
        qWarning("Failed to parse json msg");
        return;
    }

    qDebug()<<"servers got "<<QString::fromLocal8Bit(readBuf)<<"("<<readMsg.array()<<")";
    emit serversGot(readMsg.array());
}

void socketBackend::connectToServer()
{
    _connected();
}

void socketBackend::disconnectFromHost()
{
    _socket.disconnectFromHost();
}

void socketBackend::sendStringMsg(const QString &_msg)
{
    if (_socket.state() != QAbstractSocket::ConnectedState) {
        qDebug("error appeared...");
        emit errorSending("Socket is not connected");
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
    qDebug("connected...");
    QObject::connect(&_socket, &QTcpSocket::readyRead, this, &socketBackend::_onNewMsg);
    qDebug("connected signal onReadyRead...");
    emit connectedMessages();
}

void socketBackend::_disconnected()
{
    qDebug("disconnected...");
    QObject::disconnect(&_socket, &QTcpSocket::readyRead, this, &socketBackend::_onNewMsg);
    qDebug("disconnected signal onReadyRead...");
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
