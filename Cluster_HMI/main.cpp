#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "radialbar.h"
#include "serialreader.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Đăng ký RadialBar
    qmlRegisterType<RadialBar>("CustomControls", 1, 0, "RadialBar");

    // Tạo SerialReader instance
    SerialReader serialReader;

    // Đưa SerialReader vào QML context
    engine.rootContext()->setContextProperty("serialReader", &serialReader);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
