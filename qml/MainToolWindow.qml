import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

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