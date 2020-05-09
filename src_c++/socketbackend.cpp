#include "socketbackend.h"

socketBackend::socketBackend(QObject *parent) : QObject(parent)
{
    QObject::connect(&_socket, &QTcpSocket::disconnected, this, &socketBackend::_disconnected);
    _choosen_server = false;
}

void socketBackend::connectToHost(const QString &_hostName, quint16 _port, const QString &_name)
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
    qDebug()<<"sending name: "<<_name;
    _socket.write(_msgAsBytes, _msgAsBytes.size());

    _connected();
}

void socketBackend::connectToServer(const int num)
{
    QJsonObject msg{
        {"message_type",MessageType::ServerChoice},
        {"message", num}
    };
    QJsonDocument msg_json(msg);
    QByteArray msg_json_as_bytes = msg_json.toJson(QJsonDocument::Compact);
    _socket.write(msg_json_as_bytes, msg_json_as_bytes.size());
    if (_choosen_server) {
        _changed_server();
    } else {
        _choosen_server = true;
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
        {"message_type",MessageType::Message},
        {"message", _msg}
    };
    qDebug()<<"sending "<<_msg;
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
    QString jsonAsString(readBuf);
    QStringList jsonList = jsonAsString.split(";", QString::SkipEmptyParts);
    for (QStringList::const_iterator it = jsonList.constBegin(); it != jsonList.constEnd(); it++) {
        QString jsonWord = *it;
        qDebug()<<"handling: "<<jsonWord;
        handleCommand(jsonWord);
    }
}

void socketBackend::handleCommand(const QString &_jsonData)
{
    QJsonDocument jsonData = QJsonDocument::fromJson(_jsonData.toUtf8());

    if (jsonData.isNull() || !jsonData.isObject()) {
        qWarning("Failed to parse json msg");
        qDebug()<<jsonData;
        return;
    }
    if (jsonData["message"].isUndefined()) {
        qWarning("Failed to parse json \"message\" key");
        return;
    }
    if (jsonData["message_type"].isUndefined()) {
        qWarning("Failed to parse json \"message_type\" key");
        return;
    }

    if (jsonData["message_type"].toInt() == MessageType::Message) {
        qDebug()<<"got msg"<<jsonData;
        QJsonObject jsonMessage = jsonData["message"].toObject();
        emit msgGot(jsonMessage["data"].toString(), jsonMessage["name"].toString());
    }
    if (jsonData["message_type"].toInt() == MessageType::ServersList) {
        QJsonArray jsonMessage = jsonData["message"].toArray();
        emit serversGot(jsonMessage);
    }
    if (jsonData["message_type"].toInt() == MessageType::ForcedMove) {
        int jsonMessage = jsonData["message"].toInt();
        emit forcedMove(jsonMessage);
    }
}