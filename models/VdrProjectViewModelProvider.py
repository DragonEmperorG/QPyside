import os
import time
from datetime import datetime
from pathlib import Path

from PySide2 import QtQml
from PySide2.QtCore import Slot, Property, QObject, Signal, QPointF
from PySide2.QtGui import QColor, QBrush
from PySide2.QtCharts import QtCharts

from models.ChartViewSeriesType import ChartViewSeriesType
from models.VdrProject import VdrProject
from models.VdrProjectCollectorViewModel import VdrProjectCollectorViewModel
from models.VdrProjectMapViewPolylineModel import VdrProjectMapViewPolylineModel


# https://stackoverflow.com/questions/54687953/declaring-a-qabstractlistmodel-as-a-property-in-pyside2
class VdrProjectViewModelProvider(QObject):
    def __init__(self, engine, parent=None):
        super().__init__(parent)
        self._QQmlApplicationEngine = engine
        self.vdrProjectOpenState = False
        self.vdrProjectName = ''

        self.vdrProject = None
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

    @Slot(QObject)
    def open_project(self, project_name_label):
        datasets_root = os.path.join(Path(__file__).resolve().parent.parent, 'datasets')
        # project_list = os.listdir(datasets_root)

        current_project_folder_name = '20220315_WHUSPARK'
        current_project_folder_path = os.path.join(datasets_root, current_project_folder_name)

        self.vdrProject = VdrProject(current_project_folder_path)
        self.vdrProjectOpenState = True
        self.vdrProjectName = current_project_folder_name
        project_name_label.setProperty("text", current_project_folder_name)

        self.vdrProjectAlkaidCollectorViewModel.setup_model_data(self.vdrProject.parse_alkaid_collector_view())

        self.vdrProjectPhoneCollectorViewModel.setup_model_data(self.vdrProject.parse_phone_collector_view())

        self.vdrProjectMapViewPolylineModel.setup_model_data(self.vdrProject.parse_map_view_polyline())

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
    @Slot(QObject, QObject, QObject)
    def test(self, chart_view: QObject, chart_view_axis_x, chart_view_axis_y):
        print('test')
        context = QtQml.QQmlContext(self._QQmlApplicationEngine.rootContext())
        context.setContextProperty("chart_view", chart_view)
        context.setContextProperty("axis_x", chart_view_axis_x)
        context.setContextProperty("axis_y", chart_view_axis_y)
        context.setContextProperty("type", ChartViewSeriesType.SeriesTypeLine.value)

        script = """chart_view.createSeries(type, "line series", axis_x, axis_y);"""
        expression = QtQml.QQmlExpression(context, chart_view, script)
        series, valueIsUndefined = expression.evaluate()
        if expression.hasError():
            print(expression.error())
            return

        if not valueIsUndefined:
            test_raw_data_frame = self.vdrProject.parse_alkaid_collector_chart_view()
            test_raw_data_point_series = test_raw_data_frame.apply(
                # s
                lambda row: QPointF(row.DATA_POS_TIMESTAMP.timestamp() * 1000, row.COLUMN_6),
                axis=1
            )
            test_raw_data_point_list = test_raw_data_point_series.tolist()
            series.append(test_raw_data_point_list)

            # show_raw_data_point_list = test_raw_data_point_list[0:20]
            # series.append(show_raw_data_point_list)

            # series.useOpenGL = True
            chart_view_axis_x.setProperty("max", test_raw_data_point_list[-1].x())
            chart_view_axis_x.setProperty("min", test_raw_data_point_list[0].x())
            chart_view_axis_y.setProperty("max", 1)
            chart_view_axis_y.setProperty("min", -1)

