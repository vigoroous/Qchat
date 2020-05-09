#include "audiobackend.h"

audioBackend::audioBackend(QObject *parent) : QObject(parent), _socket()
{
    // Set up the desired format, for example:
    _format.setSampleRate(8000);
    _format.setChannelCount(1);
    _format.setSampleSize(8);
    _format.setCodec("audio/opus");
    _format.setByteOrder(QAudioFormat::LittleEndian);
    _format.setSampleType(QAudioFormat::UnSignedInt);
    QObject::connect(&_socket, &QTcpSocket::disconnected, this, &audioBackend::_disconnected);
    QObject::connect(&_socket, &QTcpSocket::connected, this, &audioBackend::_connected);
}

void audioBackend::connectSocket(const QString &_serverAddr, quint16 port)
{
    qDebug()<<"trying to connect to "<<_serverAddr<<":"<<port;
    _socket.connectToHost(_serverAddr, port);

    if (!initInputOutputAudio()) {
        _socket.disconnectFromHost();
        emit error(QString("error occured: did not initiated audio"));
        return;
    }
}

void audioBackend::toggleStream()
{
    if (!isConnected()) return;
    (_started)? _stop() : _start() ;
    _started = !_started;
}

void audioBackend::disconnectSocket()
{
    _socket.disconnectFromHost();
}

bool audioBackend::initInputOutputAudio()
{
    bool infoI, infoO;
    infoI = QAudioDeviceInfo::defaultInputDevice().isFormatSupported(_format);
    infoO = QAudioDeviceInfo::defaultOutputDevice().isFormatSupported(_format);
    if (!infoI || !infoO) {
        qWarning() << "Default format not supported";
        return false;
    }

    _input = new QAudioInput(_format);
    _output = new QAudioOutput(_format);

    QObject::connect(_input, &QAudioInput::stateChanged, this, &audioBackend::handleInputStateChanged);
    QObject::connect(_output, &QAudioOutput::stateChanged, this, &audioBackend::handleOutputStateChanged);

    return true;
}

void audioBackend::handleInputStateChanged(QAudio::State newState)
{
    qDebug()<<"Input: "<<newState;
}

void audioBackend::handleOutputStateChanged(QAudio::State newState)
{
    qDebug()<<"Output: "<<newState;
}

bool audioBackend::isConnected()
{
    return _socket.state() == QAbstractSocket::ConnectedState;
}

void audioBackend::_stop()
{
    qDebug()<<"stopping audio";
    _input->stop();
    _output->stop();
}

void audioBackend::_start()
{
    qDebug()<<"starting audio";
    _input->start(&_socket);
    _output->start(&_socket);
}

void audioBackend::_disconnected()
{
    qDebug()<<"disconnected";
    _stop();
    if (_output != NULL) delete _output;
    if (_input != NULL) delete _input;
    emit disconnected();
    emit statusChanged();
}

void audioBackend::_connected()
{
    qDebug()<<"connected";
    emit connected();
    emit statusChanged();
}