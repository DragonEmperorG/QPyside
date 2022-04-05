import os
import pandas as pd

from models.VdrAlkaidSensorsData import VdrAlkaidSensorsData
from models.VdrPhoneSensorsData import VdrPhoneSensorsData
from models.VdrProjectViewItem import VdrProjectViewItem


class VdrProject:
    def __init__(self, path):
        self.project_name = ""
        self.alkaid_collector = None
        self.phone_collector_list = []
        self.parse_vdr_project(path)

    def parse_vdr_project(self, path):
        current_project_collector_folder_list = os.listdir(path)
        for collector_folder in current_project_collector_folder_list:
            current_collector_folder_path = os.path.join(path, collector_folder)
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

    def parse_alkaid_collector_view(self):
        alkaid_collector_item_list = []
        alkaid_collector_pos_item = VdrProjectViewItem()
        alkaid_collector_pos_item.name = 'AlkaidPosData'
        alkaid_collector_pos_item.type = 'File'
        alkaid_collector_item_list.append(alkaid_collector_pos_item)
        alkaid_collector_data_item = VdrProjectViewItem()
        alkaid_collector_data_item.name = 'AlkaidDataData'
        alkaid_collector_data_item.type = 'File'
        alkaid_collector_item_list.append(alkaid_collector_data_item)
        return alkaid_collector_item_list

    def parse_phone_collector_view(self):
        alkaid_collector_item_list = []
        for phone_collector in self.phone_collector_list:
            alkaid_collector_pos_item = VdrProjectViewItem()
            alkaid_collector_pos_item.name = phone_collector.phone_name
            alkaid_collector_pos_item.type = 'File'
            alkaid_collector_item_list.append(alkaid_collector_pos_item)
        return alkaid_collector_item_list

