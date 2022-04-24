import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtPositioning 5.15

Map {
    id: map
    anchors.fill: parent
    plugin: vdrOsmPlugin

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
}