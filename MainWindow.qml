import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtPositioning 5.15
import QtQuick.Window 2.15

import "menus"
import "models"

import VdrProjectViewModelProvider 1.0


ApplicationWindow {
    id: mainWindow
    title: qsTr("VDR Studio")
    width: 800
    height: 600
    visible: true
    visibility: Window.Maximized

    property int singleMargin: 16

    VdrProjectViewModelProvider {
        id: vdrProjectViewModelProvider
    }

    menuBar: MainMenuBar {
    }

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        Item {
            id: toolWindowsComponent
            implicitWidth: 600
            SplitView.minimumWidth : toolWindowsLeftDockTabBar.height

            // http://igorkam.blogspot.com/2018/03/qml-vertical-tabbar.html
            Item {
                id: baseTabBar
                width: projectToolTabButton.height
                height: parent.height

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
                            y: baseTabBar.height
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
            }

            StackLayout {
                width: parent.width - baseTabBar.width
                anchors.right: toolWindowsComponent.right

                currentIndex: toolWindowsLeftDockTabBar.currentIndex

                Item {
                    id: mapToolTab
                }

                Item {
                    id: projectToolTab

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: singleMargin

                        ColumnLayout {
                            id: singleProjectColumnLayout

                            Label {
                                text: qsTr("Project Name")
                                font.bold: true
                            }

                            Label {
                                id: projectNameValueLabel
                                text: vdrProjectViewModelProvider.vdr_project_name
                            }

                            ColumnLayout {
                                id: singleProjectCollectorColumnLayout
                                Layout.leftMargin: singleMargin
                                Layout.fillHeight: true

                                Label {
                                    text: qsTr("Alkaid")
                                    font.bold: true
                                }

                                ListView {
                                    id: vdrProjectAlkaidCollectorListView
                                    Layout.fillHeight: true
                                    Layout.minimumHeight: 32
                                    Layout.leftMargin: singleMargin
                                    spacing: 8
                                    model: vdrProjectViewModelProvider.alkaid_collector_view_model
                                    delegate: Row {
                                        spacing: 16

                                        Text { text: name }
                                        Text { text: type }
                                        Text { text: counts }
                                        Text { text: start_timestamp }
                                        Text { text: stop_timestamp }
                                    }
                                }

                                Label {
                                    text: qsTr("Phone")
                                    font.bold: true
                                }

                                ColumnLayout {
                                    Layout.minimumHeight: 48
                                    Layout.leftMargin: singleMargin
                                    Layout.fillHeight: true

                                    ListView {
                                        id: vdrProjectPhoneCollectorListView
                                        Layout.fillHeight: true
                                        spacing: 8
                                        model: vdrProjectViewModelProvider.phone_collector_view_model
                                        delegate: Row {
                                            spacing: 16

                                            Text { text: name }
                                            Text { text: type }
                                            Text { text: counts }
                                            Text { text: start_timestamp }
                                            Text { text: stop_timestamp }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

            }
        }

        Item {
            SplitView.fillWidth: true

            Map {
                id: map
                anchors.fill: parent
                plugin: vdrOsmPlugin

                center {
                    longitude: 114.4038712
                    latitude: 30.4554388
                }
                zoomLevel: 22

                MapItemView {
                    model: vdrProjectViewModelProvider.map_view_polyline_model
                    delegate: MapPolyline {
                        line.width: 3
                        line.color: 'red'
                        path: polylineData
                    }
                }
            }
        }

    }

    Plugin {
        id: vdrOsmPlugin
        name: "osm"

        PluginParameter {
            name: "osm.mapping.highdpi_tiles";
            value: "True"
        }
        PluginParameter {
            name: "osm.mapping.providersrepository.disabled";
            value: "True"
        }
    }

}

