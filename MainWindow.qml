import QtQuick 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15

import "menus"
import "models"

import VdrPhoneSensorDataModel 1.0


ApplicationWindow {
    id: mainWindow
    width: 800
    height: 600
    visible: true
    title: qsTr("Hello World")

    VdrPhoneSensorDataModel {
        id: vdrPhoneSensorDataModel1
    }

    menuBar: mainMenu

    MainMenuBar {
        id: mainMenu
    }

    Plugin {
        id: myPlugin
        name: "osm"
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: myPlugin;
        center {
            latitude: 59.9485
            longitude: 10.7686
        }
        zoomLevel: 13
    }

}
