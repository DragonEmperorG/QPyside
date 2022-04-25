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
    readonly property int fontSizeDefault: Qt.application.font.pixelSize
    readonly property int fontSizeMedium: Qt.application.font.pixelSize * 1.5
    readonly property int fontSizeLarge: Qt.application.font.pixelSize * 2
    readonly property int fontSizeExtraLarge: Qt.application.font.pixelSize * 5

    readonly property int layoutMargin: 8
    readonly property int layoutDoubleMargin: layoutMargin * 2

    readonly property int layoutSpacing: 8


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

    // https://felgo.com/doc/qt/qtquickcontrols2-imagine-automotive-qml-automotive-qml/
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

                    ColumnLayout {
                        id: projectScrollView
                        // https://doc.qt.io/qt-5/qml-qtquick-item.html#clip-prop
                        clip: true
                        spacing: layoutSpacing

                        ColumnLayout {
                            spacing: layoutSpacing

                            Layout.margins: layoutMargin

                            ColumnLayout {
                                spacing: layoutSpacing

                                Label {
                                    id: projectNameLabelId
                                    text: qsTr("Project Name")
                                    font.pixelSize: fontSizeDefault
                                    font.bold: true
                                }

                                Label {
                                    id: projectNameValueId
                                    text: vdrProjectViewModelProvider.vdr_project_name
                                    font.pixelSize: fontSizeDefault
                                    font.bold: true
                                }
                            }

                            ColumnLayout {
                                spacing: layoutSpacing

                                Layout.leftMargin: layoutDoubleMargin

                                Label {
                                    id: vdrProjectAlkaidCollectorName
                                    text: qsTr("Alkaid")
                                    font.pixelSize: fontSizeDefault
                                    font.bold: true
                                }

                                // https://stackoverflow.com/questions/42550635/qt-height-issue-of-scrollablepage
                                Frame {
                                    id: vdrProjectAlkaidCollectorFrame
                                    leftPadding: 1
                                    rightPadding: 1
                                    topPadding: 1
                                    bottomPadding: 1

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 48

                                    ListView {
                                        id: vdrProjectAlkaidCollectorListView
                                        // spacing: layoutSpacing
                                        clip: true
                                        anchors.fill: parent
                                        flickableDirection: Flickable.HorizontalAndVerticalFlick
                                        contentWidth: contentItem.childrenRect.width
                                        contentHeight: contentItem.childrenRect.height

                                        ScrollIndicator.horizontal: ScrollIndicator {
                                            parent: vdrProjectAlkaidCollectorFrame
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.bottom: parent.bottom
                                            anchors.bottomMargin: 1
                                        }

                                       ScrollIndicator.vertical: ScrollIndicator {
                                            parent: vdrProjectAlkaidCollectorFrame
                                            anchors.top: parent.top
                                            anchors.right: parent.right
                                            anchors.rightMargin: 1
                                            anchors.bottom: parent.bottom
                                       }

                                        model: vdrProjectViewModelProvider.alkaid_collector_view_model
                                        delegate: ItemDelegate {
                                            id: vdrProjectAlkaidCollectorListViewDelegate


                                            height: 48
                                            contentItem: RowLayout {
                                                spacing: 16

                                                // https://stackoverflow.com/questions/50178597/how-to-add-a-custom-role-to-qfilesystemmodel/50180682#50180682
                                                CheckBox {
                                                    text: qsTr("Alkaid")
                                                    checked: alkaid_polyline_enable
                                                    onCheckedChanged: {
                                                        vdrProjectViewModelProvider.switch_map_polyline(0, index, 0, checked)
                                                    }
                                                }
                                                Label { text: name }
                                                Label { text: type }
                                                Label { text: counts }
                                                Label { text: start_timestamp }
                                                Label { text: stop_timestamp }
                                            }
                                        }
                                    }
                                }

                                Label {
                                    id: vdrProjectPhoneCollectorName
                                    text: qsTr("Phone")
                                    font.pixelSize: fontSizeDefault
                                    font.bold: true
                                }

                                Frame {
                                    id: vdrProjectPhoneCollectorFrame
                                    leftPadding: 1
                                    rightPadding: 1
                                    topPadding: 1
                                    bottomPadding: 1

                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    ListView {
                                        id: vdrProjectPhoneCollectorListView
                                        clip: true
                                        anchors.fill: parent
                                        flickableDirection: Flickable.HorizontalAndVerticalFlick
                                        contentWidth: contentItem.childrenRect.width
                                        contentHeight: contentItem.childrenRect.height

                                        ScrollIndicator.horizontal: ScrollIndicator {
                                            parent: vdrProjectPhoneCollectorFrame
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.bottom: parent.bottom
                                            anchors.bottomMargin: 1
                                        }

                                       ScrollIndicator.vertical: ScrollIndicator {
                                            parent: vdrProjectPhoneCollectorFrame
                                            anchors.top: parent.top
                                            anchors.right: parent.right
                                            anchors.rightMargin: 1
                                            anchors.bottom: parent.bottom
                                       }

                                        model: vdrProjectViewModelProvider.phone_collector_view_model
                                        delegate: ItemDelegate {
                                            id: vdrProjectAlkaidCollectorListViewDelegate
                                            height: 48
                                            contentItem: RowLayout {
                                                spacing: 16

                                                // https://stackoverflow.com/questions/50178597/how-to-add-a-custom-role-to-qfilesystemmodel/50180682#50180682
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

                                                Label { text: name }
                                                Label { text: type }
                                                Label { text: counts }
                                                Label { text: start_timestamp }
                                                Label { text: stop_timestamp }
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

                    }
                }
            }

        }
    }

}

