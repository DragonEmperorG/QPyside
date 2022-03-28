import os
import pandas as pd
from pathlib import Path

from PySide2.QtCore import Slot, QObject


class VdrProject(QObject):
    def __init__(self):
        super().__init__()

    @Slot()
    def open_project(self):
        datasets_root = os.path.join(Path(__file__).resolve().parent.parent, 'datasets')
        project_list = os.listdir(datasets_root)

        current_project_folder_name = '20220315_WHUSPARK_TEST'
        current_project_folder_path = os.path.join(datasets_root, current_project_folder_name)
        current_project_collector_folder_list = os.listdir(current_project_folder_path)
        for collector_folder in current_project_collector_folder_list:
            current_collector_folder_path = os.path.join(current_project_folder_path, collector_folder)
            if collector_folder == 'Alkaid':
                self.parse_alkaid_collector_data(current_collector_folder_path)
            else:
                print(1)
                # self.parse_phone_collector_data(current_collector_folder_path)

    # def parse_phone_collector_data(self, path):
    #     file_list = os.listdir(path)
    #     for file in file_list:
    #         name, suffix = os.path.splitext(file)
    #         if suffix == '.pos':
    #             file_path = os.path.join(path, file)

    def parse_alkaid_collector_data(self, path):
        file_list = os.listdir(path)
        for file in file_list:
            name, suffix = os.path.splitext(file)
            if suffix == '.pos':
                file_path = os.path.join(path, file)
                alkaid_collector_raw_data = pd.read_csv(file_path, delim_whitespace=True)
                print(alkaid_collector_raw_data)
