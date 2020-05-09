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

    _input.reset(new QAudioInput(_format));
    _output.reset(new QAudioOutput(_format));

    QObject::connect(_input.get(), &QAudioInput::stateChanged, this, &audioBackend::handleInputStateChanged);
    QObject::connect(_output.get(), &QAudioOutput::stateChanged, this, &audioBackend::handleOutputStateChanged);

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
    if (_output->state() == QAudio::StoppedState && _input->state() == QAudio::StoppedState) return;
    qDebug()<<"stopping audio";
    _input->stop();
    _output->stop();
    _started = false;
}

void audioBackend::_start()
{
    qDebug()<<"starting audio";
    _input->setVolume(_inputVolume);
    _output->setVolume(_outputVolume);
    _input->start(&_socket);
    _output->start(&_socket);
    _started = true;
}

void audioBackend::_disconnected()
{
    qDebug()<<"disconnected";
    _stop();
    _output.release();
    _input.release();
    emit disconnected();
    emit statusChanged();
}

void audioBackend::_connected()
{
    qDebug()<<"connected";
    emit connected();
    emit statusChanged();
}

void audioBackend::setInputVolume(qreal volume)
{
    if (volume < 0.0) volume = 0.0;
    if (volume > 1.0) volume = 1.0;
    _inputVolume = volume;
    if (_input) _input->setVolume(_inputVolume);
}

void audioBackend::setOutputVolume(qreal volume)
{
    if (volume < 0.0) volume = 0.0;
    if (volume > 1.0) volume = 1.0;
    _outputVolume = volume;
    if (_output) _output->setVolume(_outputVolume);
}

void audioBackend::setNotifyInterval(int ms)
{
    if (ms < 500) ms = 500;
    if (ms > 2000) ms = 2000;
    _notifyInterval = ms;
    if (_output) _output->setNotifyInterval(ms);
}