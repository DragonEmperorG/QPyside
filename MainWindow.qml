import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtPositioning 5.15

import "menus"
import "models"

import VdrProject 1.0


ApplicationWindow {
    id: mainWindow
    width: 800
    height: 600
    visible: true
    title: qsTr("VDR Studio")

    VdrProject {
        id: testVdrProject
    }

    menuBar: mainMenu

    MainMenuBar {
        id: mainMenu
    }

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        Item {
            id: toolWindowsComponent
            implicitWidth: 200
            SplitView.minimumWidth : toolWindowsLeftDockTabBar.height

            TabBar {
                id: toolWindowsLeftDockTabBar
                width: parent.height
                height: projectToolTabButton.height

                transform: [
                    Rotation {
                        origin.x: 0
                        origin.y: 0
                        angle: -90
                    } // rotate around the upper left corner counterclockwise
                    ,Translate {
                        y: toolWindowsComponent.height
                        x: 0
                    } // move to the bottom of the base
                ]

                TabButton {
                    id: mapToolTabButton
                    text: qsTr("Map")
                }

                TabButton {
                    id: projectToolTabButton
                    text: qsTr("Project")
                }

                Component.onCompleted: {
                    currentIndex = 1
                }
            }

            StackLayout {
                width: parent.width - toolWindowsLeftDockTabBar.height
                currentIndex: toolWindowsLeftDockTabBar.currentIndex
                Item {
                    id: homeTab
                }
                Item {
                    id: discoverTab
                }
            }
        }

        Item {
            SplitView.fillWidth: true

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

    }

    Plugin {
        id: myPlugin
        name: "osm"
    }

}
