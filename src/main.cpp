/*
    SPDX-License-Identifier: GPL-2.0-or-later
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
*/

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QtQml>

#include "about.h"
#include "app.h"
#include "version-radio.h"
#include <KAboutData>
#include <KLocalizedContext>
#include <KLocalizedString>

#include "radioconfig.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("KDE"));
    QCoreApplication::setApplicationName(QStringLiteral("radio"));

    KAboutData aboutData(
                         // The program name used internally.
                         QStringLiteral("Radio"),
                         // A displayable program name string.
                         i18nc("@title", "Radio"),
                         // The program version string.
                         QStringLiteral("1.0"),
                         // Short description of what the app does.
                         i18n("Simple Radio"),
                         // The license this code is released under.
                         KAboutLicense::GPL,
                         // Copyright Statement.
                         i18n("(c) 2023"));
    aboutData.addAuthor(i18nc("@info:credit", "Alex K"),
                        i18nc("@info:credit", "Developer"),
                        QStringLiteral("unknown"),
                        QStringLiteral("https://"));
    KAboutData::setApplicationData(aboutData);

    QQmlApplicationEngine engine;

    auto config = radioConfig::self();

    qmlRegisterSingletonInstance("org.kde.radio", 1, 0, "Config", config);

    AboutType about;
    qmlRegisterSingletonInstance("org.kde.radio", 1, 0, "AboutType", &about);

    App application;
    qmlRegisterSingletonInstance("org.kde.radio", 1, 0, "App", &application);

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
