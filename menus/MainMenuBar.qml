import QtQuick 2.15
import QtQuick.Controls 2.15


MenuBar {
     Menu {
         title: qsTr("&File")
         Action { text: qsTr("&New...") }
         Action {
             text: qsTr("&Open...")
             onTriggered: {
                vdrProjectViewModelProvider.open_project()
                projectNameValueId.text = vdrProjectViewModelProvider.vdr_project_name
                vdrProjectAlkaidCollectorListView.forceLayout()
                // projectColumnLayout.visible = vdrProjectViewModelProvider.vdr_project_open_state

                projectScrollViewWidth.text = projectScrollView.width
                projectScrollViewHeight.text = projectScrollView.height
                // projectColumnLayoutWidth.text = projectColumnLayout.width
                // projectColumnLayoutHeight.text = projectColumnLayout.height
                // vdrProjectAlkaidCollectorListViewWidth.text = vdrProjectAlkaidCollectorListView.width
                vdrProjectAlkaidCollectorListViewHeight.text = vdrProjectAlkaidCollectorListView.height
            }
         }
         Action { text: qsTr("&Save") }
         Action { text: qsTr("Save &As...") }
         MenuSeparator { }
         Action { text: qsTr("&Quit") }
     }
    Menu {
        title: qsTr("&Edit")
        Action { text: qsTr("Cu&t") }
        Action { text: qsTr("&Copy") }
        Action { text: qsTr("&Paste") }
    }
    Menu {
        title: qsTr("R&un")
        Action {
            text: qsTr("Test")
            onTriggered: {
                projectNameValueId.text = '012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789'
            }
        }
    }
    Menu {
        title: qsTr("&Help")
        Action { text: qsTr("&About") }
    }
}