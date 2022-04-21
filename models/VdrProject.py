import os

from models.VdrAlkaidSensorsData import VdrAlkaidSensorsData
from models.VdrPhoneSensorsData import VdrPhoneSensorsData
from models.VdrProjectCollectorViewItem import VdrProjectCollectorViewItem
from models.VdrProjectMapViewPolylineItem import VdrProjectMapViewPolylineItem


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

        self.clip_collector_data()

    def parse_phone_collector_data(self, path):
        file_list = os.listdir(path)
        file_path = os.path.join(path, file_list[0], 'VdrExperimentData.csv')
        phone_collector = VdrPhoneSensorsData(os.path.basename(path), file_path)
        self.phone_collector_list.append(phone_collector)

    def parse_alkaid_collector_data(self, path):
        self.alkaid_collector = VdrAlkaidSensorsData(path)

    def parse_alkaid_collector_view(self):
        alkaid_collector_item_list = []
        alkaid_collector_pos_item = VdrProjectCollectorViewItem()
        alkaid_collector_pos_item.name = 'AlkaidPosData'
        alkaid_collector_pos_item.type = 'File'
        alkaid_collector_pos_item.counts = self.alkaid_collector.pos_data_row_counts
        alkaid_collector_pos_item.start_timestamp = self.alkaid_collector.pos_data_start_timestamp.strftime('%Y-%m-%d %H:%M:%S.%f')
        alkaid_collector_pos_item.stop_timestamp = self.alkaid_collector.pos_data_stop_timestamp.strftime('%Y-%m-%d %H:%M:%S.%f')
        alkaid_collector_pos_item.alkaid_polyline_enable = True
        alkaid_collector_item_list.append(alkaid_collector_pos_item)
        alkaid_collector_data_item = VdrProjectCollectorViewItem()
        alkaid_collector_data_item.name = 'AlkaidDataData'
        alkaid_collector_data_item.type = 'File'
        alkaid_collector_data_item.counts = self.alkaid_collector.data_data_row_counts
        alkaid_collector_data_item.start_timestamp = self.alkaid_collector.data_data_start_timestamp.strftime('%Y-%m-%d %H:%M:%S.%f')
        alkaid_collector_data_item.stop_timestamp = self.alkaid_collector.data_data_stop_timestamp.strftime('%Y-%m-%d %H:%M:%S.%f')
        alkaid_collector_data_item.alkaid_polyline_enable = False
        alkaid_collector_item_list.append(alkaid_collector_data_item)

        for index, alkaid_collector_item in enumerate(alkaid_collector_item_list):
            alkaid_collector_item.item_index = index
        return alkaid_collector_item_list

    def parse_phone_collector_view(self):
        alkaid_collector_item_list = []
        for phone_collector in self.phone_collector_list:
            alkaid_collector_pos_item = VdrProjectCollectorViewItem()
            alkaid_collector_pos_item.name = phone_collector.phone_name
            alkaid_collector_pos_item.type = 'File'
            alkaid_collector_pos_item.counts = phone_collector.row_counts
            alkaid_collector_pos_item.start_timestamp = phone_collector.start_timestamp.strftime('%Y-%m-%d %H:%M:%S.%f')
            alkaid_collector_pos_item.stop_timestamp = phone_collector.stop_timestamp.strftime('%Y-%m-%d %H:%M:%S.%f')
            alkaid_collector_pos_item.alkaid_polyline_enable = False
            alkaid_collector_item_list.append(alkaid_collector_pos_item)
        return alkaid_collector_item_list

    def parse_map_view_polyline(self):
        map_view_polyline_item_list = []

        alkaid_collector_polyline_item = VdrProjectMapViewPolylineItem()
        alkaid_collector_polyline_item.polyline_enable = True
        alkaid_collector_polyline_item.polyline_data = self.alkaid_collector.polyline_path
        map_view_polyline_item_list.append(alkaid_collector_polyline_item)

        for phone_collector in self.phone_collector_list:
            phone_collector_alkaid_polyline_item = VdrProjectMapViewPolylineItem()
            phone_collector_alkaid_polyline_item.polyline_enable = False
            phone_collector_alkaid_polyline_item.polyline_data = phone_collector.alkaid_polyline_path
            map_view_polyline_item_list.append(phone_collector_alkaid_polyline_item)
            phone_collector_gnss_polyline_item = VdrProjectMapViewPolylineItem()
            phone_collector_gnss_polyline_item.polyline_enable = False
            phone_collector_gnss_polyline_item.polyline_data = phone_collector.gnss_polyline_path
            map_view_polyline_item_list.append(phone_collector_gnss_polyline_item)

        return map_view_polyline_item_list

    def clip_collector_data(self):
        phone_collector_start_timestamp_list = []
        phone_collector_stop_timestamp_list = []
        for phone_collector in self.phone_collector_list:
            phone_collector_start_timestamp_list.append(phone_collector.start_timestamp)
            phone_collector_stop_timestamp_list.append(phone_collector.stop_timestamp)

        phone_collector_intersection_start_timestamp = max(phone_collector_start_timestamp_list)
        phone_collector_intersection_stop_timestamp = min(phone_collector_stop_timestamp_list)

        for phone_collector in self.phone_collector_list:
            phone_collector.clip_data(
                phone_collector_intersection_start_timestamp,
                phone_collector_intersection_stop_timestamp
            )
        self.alkaid_collector.clip_data(
                phone_collector_intersection_start_timestamp,
                phone_collector_intersection_stop_timestamp
            )
