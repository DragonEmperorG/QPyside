import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "maps"
import "menus"
import "models"

import VdrProjectViewModelProvider 1.0


ApplicationWindow {
    id: mainWindow
    title: qsTr("VDR Studio")
    width: 1600
    height: 900
    minimumWidth: 1280
    minimumHeight: 720
    visible: true

    Material.theme: Material.System

    readonly property int fontSizeExtraSmall: Qt.application.font.pixelSize * 0.8
    readonly property int fontSizeMedium: Qt.application.font.pixelSize * 1.5
    readonly property int fontSizeLarge: Qt.application.font.pixelSize * 2
    readonly property int fontSizeExtraLarge: Qt.application.font.pixelSize * 5

    property int singleMargin: 16

    // property bool scrollBarVisible: projectNameLabelId.height + projectNameValueId.height + vdrProjectAlkaidCollectorName.height + vdrProjectPhoneCollectorListView.contentHeight + vdrProjectPhoneCollectorName.height + vdrProjectAlkaidCollectorListView.contentHeight > projectScrollView.height

    Component.onCompleted: {
        x = Screen.width / 2 - width / 2
        y = Screen.height / 2 - height / 2
    }

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }

    VdrProjectViewModelProvider {
        id: vdrProjectViewModelProvider
    }

    menuBar: MainMenuBar {
    }

    Frame {
        id: mainFrame
        anchors.fill: parent

        SplitView {
            id: mainSplitView
            anchors.fill: parent
            orientation: Qt.Horizontal

            Item {
                id: toolWindowsComponent
                SplitView.preferredWidth: 600
                height: parent.height
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
                    id: baseStackLayout
                    width: parent.width - baseTabBar.width

                    height: parent.height
                    anchors.right: toolWindowsComponent.right

                    currentIndex: toolWindowsLeftDockTabBar.currentIndex

                    Item {
                        id: mapToolTab
                    }


                     Item {
                        id: projectScrollView
                        // https://doc.qt.io/qt-5/qml-qtquick-item.html#clip-prop
                        clip: true

                        Text {
                            id: projectNameLabelId
                            height: 48
                            text: qsTr("Project Name")
                            font.bold: true
                        }

                        Text {
                            id: projectNameValueId
                            height: 48
                            anchors.top: projectNameLabelId.bottom
                            text: vdrProjectViewModelProvider.vdr_project_name
                        }

                        Text {
                            id: vdrProjectAlkaidCollectorName
                            height: 48
                            anchors.top: projectNameValueId.bottom
                            text: qsTr("Alkaid")
                            font.bold: true
                        }

                        // https://stackoverflow.com/questions/42550635/qt-height-issue-of-scrollablepage
                        Frame {
                            ListView {
                                id: vdrProjectAlkaidCollectorListView
                                anchors.top: vdrProjectAlkaidCollectorName.bottom
                                spacing: singleMargin
                                height: contentItem.height
                                // flickableDirection: Flickable.AutoFlickIfNeeded
                                model: vdrProjectViewModelProvider.alkaid_collector_view_model
                                delegate: vdrProjectAlkaidCollectorListViewDelegate
                            }
                        }

                        Component {
                            id: vdrProjectAlkaidCollectorListViewDelegate
                            Item {
                                height: 72
                                Row {
                                    spacing: 16

                                    // https://stackoverflow.com/questions/50178597/how-to-add-a-custom-role-to-qfilesystemmodel/50180682#50180682
                                    CheckBox {
                                        text: qsTr("Alkaid")
                                        checked: alkaid_polyline_enable
                                        onCheckedChanged: {
                                            vdrProjectViewModelProvider.switch_map_polyline(0, index, 0, checked)
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


                        Text {
                            id: vdrProjectPhoneCollectorName
                            height: 48
                            anchors.top: vdrProjectAlkaidCollectorListView.bottom
                            text: qsTr("Phone")
                            font.bold: true
                        }

                        Frame {
                            ListView {
                                id: vdrProjectPhoneCollectorListView
                                anchors.top: vdrProjectPhoneCollectorName.bottom
                                anchors.bottom: projectScrollView.bottom
                                model: vdrProjectViewModelProvider.phone_collector_view_model
                                delegate: Row {
                                    spacing: 16

                                    CheckBox {
                                        text: qsTr("Alkaid")
                                        checked: alkaid_polyline_enable
                                        onCheckedChanged: {
                                            vdrProjectViewModelProvider.switch_map_polyline(1, index, 0, checked)
                                        }
                                    }

                                    CheckBox {
                                        text: qsTr("GNSS")
                                        checked: gnss_polyline_enable
                                        onCheckedChanged: {
                                            vdrProjectViewModelProvider.switch_map_polyline(1, index, 1, checked)
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

            Item {
                SplitView.preferredWidth: 800
            }

            Item {
                SplitView.fillWidth: true

                MainMap {
                }

                GroupBox {
                    title: "Debug"
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right

                    GridLayout {
                        columns: 2

                        Label { text: "vdrProjectViewModelProvider.vdr_project_open_state: " } Text { text: vdrProjectViewModelProvider.vdr_project_open_state}
                        Label { text: "projectScrollView.width: " } Text { id: projectScrollViewWidth; text: projectScrollView.width}
                        // Label { text: "projectColumnLayout.width: " } Text { id: projectColumnLayoutWidth; text: projectColumnLayout.width}
                        // Label { text: "vdrProjectAlkaidCollectorListView.width: " } Text { id: vdrProjectAlkaidCollectorListViewWidth; text: vdrProjectAlkaidCollectorListView.width}
                        Label { text: "projectScrollView.height: " } Text { id: projectScrollViewHeight; text: projectScrollView.height}
                        // Label { text: "projectColumnLayout.height: " } Text { id: projectColumnLayoutHeight; text: projectColumnLayout.height}
                        Label { text: "vdrProjectAlkaidCollectorListView.height: " } Text { id: vdrProjectAlkaidCollectorListViewHeight; text: vdrProjectAlkaidCollectorListView.height}
                        Label { text: "projectNameValueId.width: " } Text { id: projectNameValueIdWidth; text: projectNameValueId.width}
                        // Label { text: "projectToolTab.height: " } Text { id: projectToolTabHeight; text: projectToolTab.height}

                    }
                }
            }

        }
    }

}

