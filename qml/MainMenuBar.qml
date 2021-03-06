import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15


MenuBar {
     Menu {
         title: qsTr("&File")
         Action { text: qsTr("&New...") }
         Action {
             text: qsTr("&Open...")
             onTriggered: {
                vdrProjectViewModelProvider.open_project(projectNameValueId)
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
                vdrProjectViewModelProvider.test(vdrChartView, vdrChartViewAxisX, vdrChartViewAxisY)
            }
        }
    }
    Menu {
        title: qsTr("&Help")
        Action { text: qsTr("&About") }
    }
}