// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
import QtMultimedia 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.radio 1.0

Kirigami.ApplicationWindow {
    id: root

    title: i18n("radio")

    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 20

    onClosing: App.saveWindowGeometry(root)

    onWidthChanged: saveWindowGeometryTimer.restart()
    onHeightChanged: saveWindowGeometryTimer.restart()
    onXChanged: saveWindowGeometryTimer.restart()
    onYChanged: saveWindowGeometryTimer.restart()

    Component.onCompleted: App.restoreWindowGeometry(root)

    // This timer allows to batch update the window size change to reduce
    // the io load and also work around the fact that x/y/width/height are
    // changed when loading the page and overwrite the saved geometry from
    // the previous session.
    Timer {
        id: saveWindowGeometryTimer
        interval: 1000
        onTriggered: App.saveWindowGeometry(root)
    }

    globalDrawer: Kirigami.GlobalDrawer {
        title: i18n("radio")
        titleIcon: "applications-graphics"
        isMenu: !root.isMobile
        actions: [
            Kirigami.Action {
                text: i18n("About Radio")
                icon.name: "help-about"
                onTriggered: pageStack.layers.push('qrc:About.qml')
            },
            Kirigami.Action {
                text: i18n("Quit")
                icon.name: "application-exit"
                onTriggered: Qt.quit()
            }
        ]
    }

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

    pageStack.initialPage: page

    Kirigami.Page {
        id: page

        Layout.fillWidth: true

        title: i18n("Radio")

         actions.main: Kirigami.Action {
            text: i18n("Stop")
            icon.name: "media-playback-stop"
            onTriggered: {
                player.stop()
                heading.text = "Stopped"
            }
        }

        ColumnLayout {
            width: page.width

            anchors.centerIn: parent

             Kirigami.Heading {
                id: heading
                Layout.alignment: Qt.AlignCenter
            }

            Controls.Button {
                id: deepHouse
                Layout.alignment: Qt.AlignHCenter
                text: "1.FM - Deep House"
                onClicked: playDeepHouse()
            }

            Controls.Button {
                id: pureDance
                Layout.alignment: Qt.AlignHCenter
                text: "NonStopPlay Pure Dance"
                onClicked: playNonStopPlayPureDance()
            }

            Controls.Button {
                id: danceRadio
                Layout.alignment: Qt.AlignHCenter
                text: "NonStopPlay Dance Radio"
                onClicked: playNonStopPlayDanceRadio()
            }
        }
    }

    MediaPlayer {
        id: player
    }

    function playDeepHouse(){
        player.stop()
        player.source = "http://strm112.1.fm/deephouse_mobile_mp3"
        player.play()
        heading.text = deepHouse.text
    }
    function playNonStopPlayPureDance(){
        player.stop()
        player.source = "http://stream.nonstopplay.co.uk/nsppd-32k-aac"
        player.play()
        heading.text = pureDance.text
    }
    function playNonStopPlayDanceRadio(){
        player.stop()
        player.source = "http://stream.nonstopplay.co.uk/nsp-192k-mp3"
        player.play()
        heading.text = danceRadio.text
    }
}
