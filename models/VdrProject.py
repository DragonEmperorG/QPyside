import os
import pandas as pd
from pathlib import Path

from PySide2.QtCore import Slot, QAbstractItemModel

from models.VdrAlkaidSensorsData import VdrAlkaidSensorsData
from models.VdrPhoneSensorsData import VdrPhoneSensorsData


class VdrProjectModel(QAbstractItemModel):
    def __init__(self):
        super().__init__()
        self.alkaid_collector = None
        self.phone_collector_list = []

    @Slot()
    def open_project(self):
        datasets_root = os.path.join(Path(__file__).resolve().parent.parent, 'datasets')
        # project_list = os.listdir(datasets_root)

        current_project_folder_name = '20220315_WHUSPARK_TEST'
        current_project_folder_path = os.path.join(datasets_root, current_project_folder_name)
        current_project_collector_folder_list = os.listdir(current_project_folder_path)
        for collector_folder in current_project_collector_folder_list:
            current_collector_folder_path = os.path.join(current_project_folder_path, collector_folder)
            if collector_folder == 'Alkaid':
                self.parse_alkaid_collector_data(current_collector_folder_path)
            else:
                self.parse_phone_collector_data(current_collector_folder_path)

    def parse_phone_collector_data(self, path):
        file_list = os.listdir(path)
        file_path = os.path.join(path, file_list[0], 'VdrExperimentData.csv')
        phone_collector_raw_data = pd.read_csv(
            file_path,
            header=None
        )
        phone_collector = VdrPhoneSensorsData()
        phone_collector.phone_name = os.path.basename(path)
        phone_collector.raw_csv_data = phone_collector_raw_data
        self.phone_collector_list.append(phone_collector)

    def parse_alkaid_collector_data(self, path):
        file_list = os.listdir(path)
        for file in file_list:
            name, suffix = os.path.splitext(file)
            file_path = os.path.join(path, file)
            if suffix == '.pos':
                alkaid_collector_raw_pos_data = pd.read_csv(
                    file_path,
                    delim_whitespace=True
                )
                alkaid_collector_raw_pos_data.rename(
                    columns={"#timestamp": "timestamp"}
                )
                if self.alkaid_collector is None:
                    self.alkaid_collector = VdrAlkaidSensorsData()
                self.alkaid_collector.raw_pos_data = alkaid_collector_raw_pos_data
            if suffix == '.data':
                alkaid_collector_raw_data_data = pd.read_csv(
                    file_path,
                    header=None
                )
                if self.alkaid_collector is None:
                    self.alkaid_collector = VdrAlkaidSensorsData()
                self.alkaid_collector.raw_data_data = alkaid_collector_raw_data_data
