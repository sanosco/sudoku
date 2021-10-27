#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "sudoku_item.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<SudokuItem>("sanosco.snowsparkle.sudoku", 1, 1, "SudokuItem");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
