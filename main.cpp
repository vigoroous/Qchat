#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>

#include "src_c++/msglist.h"
#include "src_c++/socketbackend.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    //to_Delete_Styles____________________________________
    QGuiApplication::setApplicationName("Qchat");
    QGuiApplication::setOrganizationName("QchatProject");
    QSettings settings;
    QString style = QQuickStyle::name();
    if (!style.isEmpty())
        settings.setValue("style", style);
    else
        QQuickStyle::setStyle(settings.value("style").toString());
    engine.rootContext()->setContextProperty("availableStyles", QQuickStyle::availableStyles());
    //____________________________________________________

    //REGISTERING_TYPES___________________________________
    qmlRegisterType<msgList>("usr.msgList", 1 , 0, "MsgListModel");
    qmlRegisterType<socketBackend>("usr.socketBackend", 1, 0, "TCPSocket");
    //____________________________________________________
    engine.load(QUrl("qrc:/main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
