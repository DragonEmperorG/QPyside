import os

from pathlib import Path

from PySide2 import QtCore
from PySide2.QtCore import Slot, Property, QAbstractListModel, Qt, QModelIndex, QObject, Signal

from models.VdrAlkaidSensorsData import VdrAlkaidSensorsData
from models.VdrPhoneSensorsData import VdrPhoneSensorsData
from models.VdrProject import VdrProject
from models.VdrProjectCollectorViewModel import VdrProjectCollectorViewModel
from models.VdrProjectViewItem import VdrProjectViewItem


class VdrProjectViewModelProvider(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.vdrProjectAlkaidCollectorViewModel = VdrProjectCollectorViewModel()
        self.vdrProjectPhoneCollectorViewModel = VdrProjectCollectorViewModel()

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

    @Slot()
    def open_project(self):
        datasets_root = os.path.join(Path(__file__).resolve().parent.parent, 'datasets')
        # project_list = os.listdir(datasets_root)

        current_project_folder_name = '20220315_WHUSPARK_TEST'
        current_project_folder_path = os.path.join(datasets_root, current_project_folder_name)

        current_project = VdrProject(current_project_folder_path)
        self.vdrProjectAlkaidCollectorViewModel.setup_model_data(current_project.parse_alkaid_collector_view())
        self.vdrProjectPhoneCollectorViewModel.setup_model_data(current_project.parse_phone_collector_view())







