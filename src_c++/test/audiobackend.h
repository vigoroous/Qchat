#ifndef AUDIOBACKEND_H
#define AUDIOBACKEND_H

#include <QObject>
#include <QAudioOutput>
#include <QAudioInput>
#include <QAudioFormat>
#include <QAudio>
#include <QAudioDeviceInfo>
#include <QTcpSocket>
#include <QAbstractSocket>
#include <QDebug>

class audioBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY statusChanged)
    Q_PROPERTY(qreal outputVolume MEMBER _outputVolume WRITE setOutputVolume)
    Q_PROPERTY(qreal inputVolume MEMBER _inputVolume WRITE setInputVolume)
    Q_PROPERTY(int notifyInterval MEMBER _notifyInterval WRITE setNotifyInterval)

public:
    explicit audioBackend(QObject *parent = nullptr);

public slots:
    void connectSocket(const QString &_serverAddr, quint16 port);
    void disconnectSocket();
    bool isConnected();
    void toggleStream();
    void setInputVolume(qreal volume);
    void setOutputVolume(qreal volume);
    void setNotifyInterval(int ms);

signals:
    void connected();
    void disconnected();
    void statusChanged();
    void error(const QString &err);

private:
    std::unique_ptr<QAudioOutput> _output;
    std::unique_ptr<QAudioInput> _input;
    QTcpSocket _socket;
    QAudioFormat _format;
    bool _started = false;

    bool initInputOutputAudio();
    void handleInputStateChanged(QAudio::State newState);
    void handleOutputStateChanged(QAudio::State newState);
    qreal _inputVolume = 1.0;
    qreal _outputVolume = 1.0;
    int _notifyInterval = 1000;
    void _disconnected();
    void _connected();
    void _stop();
    void _start();
};

#endif // AUDIOBACKEND_H