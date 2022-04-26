import os
from enum import Enum, auto
from pathlib import Path

from PySide2 import QtQml
from PySide2.QtCore import Slot, Property, QObject, Signal, Qt
from PySide2.QtCharts import QtCharts
from PySide2.QtGui import QColor

from models.VdrProject import VdrProject
from models.VdrProjectCollectorViewModel import VdrProjectCollectorViewModel
from models.VdrProjectMapViewPolylineModel import VdrProjectMapViewPolylineModel


# https://code.qt.io/cgit/qt/qtcharts.git/tree/src/chartsqml2/declarativechart_p.h#n105
class SeriesType(Enum):
    SeriesTypeLine = 0
    SeriesTypeArea = auto()
    SeriesTypeBar = auto()
    SeriesTypeStackedBar = auto()
    SeriesTypePercentBar = auto()
    SeriesTypePie = auto()
    SeriesTypeScatter = auto()
    SeriesTypeSpline = auto()
    SeriesTypeHorizontalBar = auto()
    SeriesTypeHorizontalStackedBar = auto()
    SeriesTypeHorizontalPercentBar = auto()
    SeriesTypeBoxPlot = auto()
    SeriesTypeCandlestick = auto()


# https://stackoverflow.com/questions/54687953/declaring-a-qabstractlistmodel-as-a-property-in-pyside2
class VdrProjectViewModelProvider(QObject):
    def __init__(self, engine, parent=None):
        super().__init__(parent)
        self._QQmlApplicationEngine = engine
        self.vdrProjectOpenState = False
        self.vdrProjectName = ''

        self.vdrProjectAlkaidCollectorViewModel = VdrProjectCollectorViewModel()
        self.vdrProjectPhoneCollectorViewModel = VdrProjectCollectorViewModel()
        self.vdrProjectMapViewPolylineModel = VdrProjectMapViewPolylineModel()

    def _vdr_project_open_state(self):
        return self.vdrProjectOpenState

    @Signal
    def vdr_project_open_state_changed(self):
        pass

    vdr_project_open_state = Property(
        bool,
        _vdr_project_open_state,
        notify=vdr_project_open_state_changed
    )

    def _vdr_project_name(self):
        return self.vdrProjectName

    @Signal
    def vdr_project_name_changed(self):
        pass

    vdr_project_name = Property(
        str,
        _vdr_project_name,
        notify=vdr_project_name_changed
    )

    def _alkaid_collector_view_model(self):
        return self.vdrProjectAlkaidCollectorViewModel

    @Signal
    def alkaid_collector_view_model_changed(self):
        pass

    alkaid_collector_view_model = Property(
        QObject,
        _alkaid_collector_view_model,
        notify=alkaid_collector_view_model_changed
    )

    def _phone_collector_view_model(self):
        return self.vdrProjectPhoneCollectorViewModel

    @Signal
    def phone_collector_view_model_changed(self):
        pass

    phone_collector_view_model = Property(
        QObject,
        _phone_collector_view_model,
        notify=phone_collector_view_model_changed
    )

    def _map_view_polyline_model(self):
        return self.vdrProjectMapViewPolylineModel

    @Signal
    def map_view_polyline_model_changed(self):
        pass

    map_view_polyline_model = Property(
        QObject,
        _map_view_polyline_model,
        notify=map_view_polyline_model_changed
    )

    @Slot()
    def open_project(self):
        datasets_root = os.path.join(Path(__file__).resolve().parent.parent, 'datasets')
        # project_list = os.listdir(datasets_root)

        current_project_folder_name = '20220315_WHUSPARK'
        current_project_folder_path = os.path.join(datasets_root, current_project_folder_name)

        current_project = VdrProject(current_project_folder_path)
        self.vdrProjectOpenState = True
        self.vdrProjectName = current_project_folder_name
        self.vdrProjectAlkaidCollectorViewModel.setup_model_data(current_project.parse_alkaid_collector_view())
        self.vdrProjectPhoneCollectorViewModel.setup_model_data(current_project.parse_phone_collector_view())
        self.vdrProjectMapViewPolylineModel.setup_model_data(current_project.parse_map_view_polyline())

    @Slot(int, int, int, bool)
    def switch_map_polyline(self, collector_index: int, item_index: int, type: int, value: bool):
        print('switch_map_polyline:' + ' ' + str(collector_index) + ' ' + str(item_index) + ' ' + str(type) + ' ' + str(value))
        if collector_index == 0:
            if item_index == 0:
                self.vdrProjectAlkaidCollectorViewModel.update_map_polyline(item_index, type, value)
                self.vdrProjectMapViewPolylineModel.update_map_polyline(item_index, value)
        elif collector_index == 1:
            self.vdrProjectPhoneCollectorViewModel.update_map_polyline(item_index, type, value)
            self.vdrProjectMapViewPolylineModel.update_map_polyline(1 + item_index*2+type, value)

    # https://stackoverflow.com/questions/57536401/how-to-add-qml-scatterseries-to-existing-qml-defined-chartview
    @Slot(QObject)
    def test(self, chart_view: QObject):
        print('test')
        context = QtQml.QQmlContext(self._QQmlApplicationEngine.rootContext())
        context.setContextProperty("chart_view", chart_view)
        chart_axis_x = QtCharts.QValueAxis()
        chart_axis_y = QtCharts.QValueAxis()
        context.setContextProperty("axis_x", chart_axis_x)
        context.setContextProperty("axis_y", chart_axis_y)
        context.setContextProperty("type", SeriesType.SeriesTypeScatter.value)
        script = """chart_view.createSeries(type, "scatter series", axis_x, axis_y);"""
        expression = QtQml.QQmlExpression(context, chart_view, script)
        serie, valueIsUndefined = expression.evaluate()
        if expression.hasError():
            print(expression.error())
            return

        import random

        mx, Mx = chart_axis_x.property("min"), chart_axis_x.property("max")
        my, My = chart_axis_y.property("min"), chart_axis_y.property("max")
        if not valueIsUndefined:
            for _ in range(100):
                x = random.uniform(mx, Mx)
                y = random.uniform(my, My)
                serie.append(x, y)
            # https://doc.qt.io/qt-5/qml-qtcharts-scatterseries.html#borderColor-prop
            serie.setProperty("borderColor", QtGui.QColor("salmon"))
            # https://doc.qt.io/qt-5/qml-qtcharts-scatterseries.html#brush-prop
            serie.setProperty("brush", QtGui.QBrush(QtGui.QColor("green")))
            # https://doc.qt.io/qt-5/qml-qtcharts-scatterseries.html#borderColor-prop
            serie.setProperty("borderWidth", 4.0)
            return serie
