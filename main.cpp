#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>

#include "src_c++/msglist.h"
#include "src_c++/socketbackend.h"
#include "src_c++/serverslist.h"

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

    //REGISTERING_SINGLETONS_______________________________
     qmlRegisterSingletonType<serversList>("usr.serversList", 1, 0, "ServersList", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
         Q_UNUSED(engine)
         Q_UNUSED(scriptEngine)
         return new serversList();
     });
     qmlRegisterSingletonType<msgList>("usr.msgList", 1 , 0, "MsgListModel", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
         Q_UNUSED(engine)
         Q_UNUSED(scriptEngine)
         return new msgList();
    });
    //____________________________________________________
    //OBJECTS_____________________________________________
    //can move to context as new ...()
    socketBackend backend; 
    //____________________________________________________
    //SETTING_CONTEXT_____________________________________
    engine.rootContext()->setContextProperty("TCPSocket", &backend);
    //____________________________________________________

    engine.load(QUrl("qrc:/main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
