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

public:
    explicit audioBackend(QObject *parent = nullptr);

public slots:
    void connectSocket(const QString &_serverAddr, quint16 port);
    void disconnectSocket();
    bool isConnected();
    void toggleStream();

signals:
    void connected();
    void disconnected();
    void statusChanged();
    void error(const QString &err);

private:
    QAudioOutput *_output;
    QAudioInput *_input;
    QTcpSocket _socket;
    QAudioFormat _format;
    bool _started = false;

    bool initInputOutputAudio();
    void handleInputStateChanged(QAudio::State newState);
    void handleOutputStateChanged(QAudio::State newState);
    void _disconnected();
    void _connected();
    void _stop();
    void _start();
};

#endif // AUDIOBACKEND_H