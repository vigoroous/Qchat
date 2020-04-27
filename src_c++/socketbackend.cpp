#include "socketbackend.h"

socketBackend::socketBackend(QObject *parent) : QObject(parent)
{
    QObject::connect(&_socket, &QTcpSocket::disconnected, this, &socketBackend::_disconnected);
    _choosen_server = false;
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

    qDebug()<<"servers got "<<"("<<readMsg.array()<<")";
    emit serversGot(readMsg.array());
}

void socketBackend::connectToServer(const int num)
{
    QJsonObject msg{
        {"message_type",0},
        {"message", QString::number(num)}
    };
    QJsonDocument msg_json(msg);
    QByteArray msg_json_as_bytes = msg_json.toJson(QJsonDocument::Compact);
    _socket.write(msg_json_as_bytes, msg_json_as_bytes.size());
    if (_choosen_server) {
        _changed_server();
    } else {
        _choosen_server = true;
        _connected();
    }
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
    QJsonObject msg{
        {"message_type",1},
        {"message", _msg}
    };
    QJsonDocument msg_json(msg);
    QByteArray msg_json_as_bytes = msg_json.toJson(QJsonDocument::Compact);
    _socket.write(msg_json_as_bytes, msg_json_as_bytes.size());
}

bool socketBackend::isConnected()
{
    return _socket.state() == QAbstractSocket::ConnectedState;
}

bool socketBackend::choosenServer()
{
    return _choosen_server;
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

void socketBackend::_changed_server()
{
    qDebug("changed server ...");
    emit serverChanged();
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
