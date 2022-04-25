import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

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

        MainToolWindow {}

        Item {
            SplitView.fillWidth: true
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

