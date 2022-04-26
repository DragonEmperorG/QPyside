import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtCharts 2.15

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
    readonly property int layoutDoubleSpacing: layoutSpacing * 2


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
    SplitView {
        id: mainSplitView
        anchors.fill: parent
        orientation: Qt.Horizontal

        Item {
            id: toolWindowsComponent
            SplitView.preferredWidth: 512
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

                        Layout.topMargin: layoutMargin
                        Layout.leftMargin: layoutMargin

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
                            Pane {
                                id: vdrProjectAlkaidCollectorPane

                                Layout.fillWidth: true
                                Layout.preferredHeight: 128

                                ListView {
                                    id: vdrProjectAlkaidCollectorListView
                                    clip: true
                                    anchors.fill: parent
                                    flickableDirection: Flickable.HorizontalAndVerticalFlick
                                    contentWidth: contentItem.childrenRect.width
                                    contentHeight: contentItem.childrenRect.height

                                    ScrollIndicator.horizontal: ScrollIndicator {
                                        parent: vdrProjectAlkaidCollectorPane
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                    }

                                   ScrollIndicator.vertical: ScrollIndicator {
                                        parent: vdrProjectAlkaidCollectorPane
                                        anchors.top: parent.top
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                   }

                                    model: vdrProjectViewModelProvider.alkaid_collector_view_model
                                    delegate: ItemDelegate {
                                        id: vdrProjectAlkaidCollectorListViewDelegate
                                        font.pixelSize: fontSizeDefault
                                        topPadding: 0
                                        bottomPadding: 0
                                        leftPadding: 0
                                        rightPadding: 0

                                        contentItem: RowLayout {
                                            spacing: layoutDoubleSpacing

                                            // https://stackoverflow.com/questions/50178597/how-to-add-a-custom-role-to-qfilesystemmodel/50180682#50180682
                                            CheckBox {
                                                text: qsTr("Alkaid")
                                                checked: alkaid_polyline_enable
                                                onCheckedChanged: {
                                                    vdrProjectViewModelProvider.switch_map_polyline(0, index, 0, checked)
                                                }
                                            }
                                            Label {
                                                text: name
                                                font: vdrProjectAlkaidCollectorListViewDelegate.font
                                            }
                                            Label {
                                                text: type
                                                font: vdrProjectAlkaidCollectorListViewDelegate.font
                                            }
                                            Label {
                                                text: counts
                                                font: vdrProjectAlkaidCollectorListViewDelegate.font
                                            }
                                            Label {
                                                text: start_timestamp
                                                font: vdrProjectAlkaidCollectorListViewDelegate.font
                                            }
                                            Label {
                                                text: stop_timestamp
                                                font: vdrProjectAlkaidCollectorListViewDelegate.font
                                            }
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

                            Pane {
                                id: vdrProjectPhoneCollectorPane

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
                                        parent: vdrProjectPhoneCollectorPane
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                    }

                                   ScrollIndicator.vertical: ScrollIndicator {
                                        parent: vdrProjectPhoneCollectorPane
                                        anchors.top: parent.top
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                   }

                                    model: vdrProjectViewModelProvider.phone_collector_view_model
                                    delegate: ItemDelegate {
                                        id: vdrProjectPhoneCollectorListViewDelegate
                                        font.pixelSize: fontSizeDefault

                                        topPadding: 0
                                        bottomPadding: 0
                                        leftPadding: 0
                                        rightPadding: 0

                                        contentItem: RowLayout {
                                            spacing: layoutDoubleSpacing

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

                                            Label {
                                                text: name
                                                font: vdrProjectPhoneCollectorListViewDelegate.font
                                            }
                                            Label {
                                                text: type
                                                font: vdrProjectPhoneCollectorListViewDelegate.font
                                            }
                                            Label {
                                                text: counts
                                                font: vdrProjectPhoneCollectorListViewDelegate.font
                                            }
                                            Label {
                                                text: start_timestamp
                                                font: vdrProjectPhoneCollectorListViewDelegate.font
                                            }
                                            Label {
                                                text: stop_timestamp
                                                font: vdrProjectPhoneCollectorListViewDelegate.font
                                            }
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

            /*
             * https://felgo.com/doc/qt/qtcharts-index/
             * Projects created with Qt Creator's Qt Quick Application wizard are based on the Qt Quick 2 template that uses QGuiApplication by default.
             * All such QGuiApplication instances in the project must be replaced with QApplication as the module depends on Qt's Graphics View Framework for rendering.
             * https://felgo.com/doc/qt/qtcharts-qmlchart-example/
             */
            ChartView {
                id: chartView
                anchors.fill: parent
                antialiasing: true



                LineSeries {
                    id: lineSeries
                    name: "LineSeries"
                    XYPoint { x: 0; y: 0 }
                    XYPoint { x: 1.1; y: 2.1 }
                    XYPoint { x: 1.9; y: 3.3 }
                    XYPoint { x: 2.1; y: 2.1 }
                    XYPoint { x: 2.9; y: 4.9 }
                    XYPoint { x: 3.4; y: 3.0 }
                    XYPoint { x: 4.1; y: 3.3 }
                }

                //Component.onCompleted: {
                   // var serie = chartView.createSeries(ChartView.SeriesTypeLine, "Spline", axisX, axisY);
                    //vdrProjectViewModelProvider.test(serie)
                //}
            }

        }

        Item {
            SplitView.preferredWidth: 512

            MainMapWindow {
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

