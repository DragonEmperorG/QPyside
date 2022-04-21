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
                                    Layout.minimumHeight: 96
                                    Layout.leftMargin: singleMargin
                                    spacing: 8
                                    onCurrentIndexChanged: {
                                        debugIndex.text = vdrProjectAlkaidCollectorListView.currentIndex
                                    }
                                    model: vdrProjectViewModelProvider.alkaid_collector_view_model
                                    delegate: Row {
                                        spacing: 16

                                        // https://stackoverflow.com/questions/50178597/how-to-add-a-custom-role-to-qfilesystemmodel/50180682#50180682
                                        CheckBox {
                                            text: item_index
                                            checked: alkaid_polyline_enable
                                            onCheckedChanged: {
                                                vdrProjectViewModelProvider.switch_map_polyline(0, index, checked)
                                            }
                                        }
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
                                    Layout.minimumHeight: 144
                                    Layout.leftMargin: singleMargin
                                    Layout.fillHeight: true

                                    ListView {
                                        id: vdrProjectPhoneCollectorListView
                                        Layout.fillHeight: true
                                        spacing: 8
                                        model: vdrProjectViewModelProvider.phone_collector_view_model
                                        delegate: Row {
                                            spacing: 16

                                            CheckBox {
                                                text: item_index
                                                checked: alkaid_polyline_enable
                                                onCheckedChanged: {
                                                    vdrProjectViewModelProvider.switch_map_polyline(1, index, checked)
                                                }
                                            }

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
                zoomLevel: 19

                MapItemView {
                    model: vdrProjectViewModelProvider.map_view_polyline_model
                    delegate: MapPolyline {
                        line.width: 3
                        line.color: 'red'
                        path: polylineData
                    }
                }

                GroupBox {
                    title: "Map Properties"
                    anchors.top: parent.top
                    anchors.right: parent.right

                    GridLayout {
                        columns: 2

                        Label { text: "plugin: " } Text { text: map.plugin.name}
                        Label { text: "activeMapType: " } Text { text: map.activeMapType.name}
                        Label { text: "maximumZoomLevel: " } Text { text: map.maximumZoomLevel}
                        Label { text: "minimumZoomLevel: " } Text { text: map.minimumZoomLevel}
                        Label { text: "zoomLevel : " } Text { text: map.zoomLevel }
                    }
                }

                GroupBox {
                    title: "Debug"
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right

                    GridLayout {
                        columns: 2

                        Label { text: "index: " } Text { id: debugIndex; text: 'vdrProjectAlkaidCollectorListView.currentIndex'}
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

