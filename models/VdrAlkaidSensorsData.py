import os
import pandas as pd
from PySide2.QtPositioning import QGeoCoordinate

from utils.VdrFileUtils import unix_s_timestamp_parser


class VdrAlkaidSensorsData:
    _POS_TIMESTAMP = 'POS_TIMESTAMP'
    _POS_LONGITUDE = 'POS_LONGITUDE'
    _POS_LATITUDE = 'POS_LATITUDE'
    _POS_HEIGHT = 'POS_HEIGHT'
    _POS_AZIMUTH = 'POS_AZIMUTH'
    _POS_SPEED = 'POS_SPEED'
    _POS_QUALITY = 'POS_QUALITY'
    _VDR_ALKAID_SENORS_POS_DATA_NAMES_LIST = [
        _POS_TIMESTAMP,
        _POS_LONGITUDE,
        _POS_LATITUDE,
        _POS_HEIGHT,
        _POS_AZIMUTH,
        _POS_SPEED,
        _POS_QUALITY,
    ]

    _DATA_DATA_TIMESTAMP = 'DATA_DATA_TIMESTAMP'
    _DATA_POS_TIMESTAMP = 'DATA_POS_TIMESTAMP'
    _DATA_MARKER = 'DATA_MARKER'
    _COLUMN_3 = 'COLUMN_3'
    _COLUMN_4 = 'COLUMN_4'
    _COLUMN_5 = 'COLUMN_5'
    _COLUMN_6 = 'COLUMN_6'
    _COLUMN_7 = 'COLUMN_7'
    _COLUMN_8 = 'COLUMN_8'
    _COLUMN_9 = 'COLUMN_9'
    _COLUMN_10 = 'COLUMN_10'
    _COLUMN_11 = 'COLUMN_11'
    _COLUMN_12 = 'COLUMN_12'
    _COLUMN_13 = 'COLUMN_13'
    _COLUMN_14 = 'COLUMN_14'
    _COLUMN_15 = 'COLUMN_15'
    _COLUMN_16 = 'COLUMN_16'
    _COLUMN_17 = 'COLUMN_17'
    _COLUMN_18 = 'COLUMN_18'
    _COLUMN_19 = 'COLUMN_19'
    _COLUMN_20 = 'COLUMN_20'

    _VDR_ALKAID_SENORS_DATA_DATA_NAMES_LIST = [
        _DATA_DATA_TIMESTAMP,
        _DATA_POS_TIMESTAMP,
        _DATA_MARKER,
        _COLUMN_3,
        _COLUMN_4,
        _COLUMN_5,
        _COLUMN_6,
        _COLUMN_7,
        _COLUMN_8,
        _COLUMN_9,
        _COLUMN_10,
        _COLUMN_11,
        _COLUMN_12,
        _COLUMN_13,
        _COLUMN_14,
        _COLUMN_15,
        _COLUMN_16,
        _COLUMN_17,
        _COLUMN_18,
        _COLUMN_19,
        _COLUMN_20,
    ]

    def __init__(self, path):
        self.platform_name = 'alkaid'
        self.folder_path = path
        self.raw_pos_data = None
        self.raw_data_data = None
        self.clipped_analyzer_imu_data_data = None
        self.polyline_path = None

        file_list = os.listdir(path)
        for file in file_list:
            name, suffix = os.path.splitext(file)
            file_path = os.path.join(path, file)
            if suffix == '.pos':
                alkaid_collector_raw_pos_data = pd.read_csv(
                    file_path,
                    delim_whitespace=True,
                    header=0,
                    names=VdrAlkaidSensorsData._VDR_ALKAID_SENORS_POS_DATA_NAMES_LIST,
                )
                alkaid_collector_analyzer_pos_data = alkaid_collector_raw_pos_data.copy(deep=True)
                alkaid_collector_analyzer_pos_data[VdrAlkaidSensorsData._POS_TIMESTAMP] = alkaid_collector_analyzer_pos_data[VdrAlkaidSensorsData._POS_TIMESTAMP].map(unix_s_timestamp_parser)
                self.raw_pos_data = alkaid_collector_raw_pos_data
                self.analyzer_pos_data = alkaid_collector_analyzer_pos_data
            if suffix == '.data':
                alkaid_collector_raw_data_data = pd.read_csv(
                    file_path,
                    names=VdrAlkaidSensorsData._VDR_ALKAID_SENORS_DATA_DATA_NAMES_LIST
                )
                alkaid_collector_analyzer_data_data = alkaid_collector_raw_data_data.copy(deep=True)
                alkaid_collector_analyzer_data_data[VdrAlkaidSensorsData._DATA_DATA_TIMESTAMP] = alkaid_collector_analyzer_data_data[VdrAlkaidSensorsData._DATA_DATA_TIMESTAMP].map(unix_s_timestamp_parser)
                alkaid_collector_analyzer_data_data[VdrAlkaidSensorsData._DATA_POS_TIMESTAMP] = alkaid_collector_analyzer_data_data[VdrAlkaidSensorsData._DATA_POS_TIMESTAMP].map(unix_s_timestamp_parser)
                self.raw_data_data = alkaid_collector_raw_data_data
                self.analyzer_data_data = alkaid_collector_analyzer_data_data

        self.clipped_analyzer_pos_data = self.analyzer_pos_data
        self.clipped_analyzer_data_data = self.analyzer_data_data

        self.pos_data_row_counts = self.analyzer_pos_data.shape[0]
        self.pos_data_start_timestamp = self.analyzer_pos_data.loc[0, VdrAlkaidSensorsData._POS_TIMESTAMP]
        self.pos_data_stop_timestamp = self.analyzer_pos_data.loc[self.pos_data_row_counts - 1, VdrAlkaidSensorsData._POS_TIMESTAMP]

        self.data_data_row_counts = self.analyzer_data_data.shape[0]
        self.data_data_start_timestamp = self.analyzer_data_data.loc[0, VdrAlkaidSensorsData._DATA_POS_TIMESTAMP]
        self.data_data_stop_timestamp = self.analyzer_data_data.loc[self.data_data_row_counts - 1, VdrAlkaidSensorsData._DATA_POS_TIMESTAMP]

    def clip_data(self, start_timestamp, stop_timestamp):
        start_mask = self.analyzer_pos_data[VdrAlkaidSensorsData._POS_TIMESTAMP] >= start_timestamp
        stop_mask = self.analyzer_pos_data[VdrAlkaidSensorsData._POS_TIMESTAMP] <= stop_timestamp
        res_mask = start_mask == stop_mask
        self.clipped_analyzer_pos_data = self.analyzer_pos_data[res_mask].copy(deep=True)
        self.clipped_analyzer_pos_data.reset_index(drop=True, inplace=True)

        self.pos_data_row_counts = self.clipped_analyzer_pos_data.shape[0]
        self.pos_data_start_timestamp = self.clipped_analyzer_pos_data.loc[0, VdrAlkaidSensorsData._POS_TIMESTAMP]
        self.pos_data_stop_timestamp = self.clipped_analyzer_pos_data.loc[self.pos_data_row_counts - 1, VdrAlkaidSensorsData._POS_TIMESTAMP]

        clipped_analyzer_pos_data_coordinate_series = self.clipped_analyzer_pos_data.apply(
            lambda row: QGeoCoordinate(row.POS_LATITUDE, row.POS_LONGITUDE),
            axis=1
        )
        self.polyline_path = clipped_analyzer_pos_data_coordinate_series.tolist()

        start_mask = self.analyzer_data_data[VdrAlkaidSensorsData._DATA_POS_TIMESTAMP] >= start_timestamp
        stop_mask = self.analyzer_data_data[VdrAlkaidSensorsData._DATA_POS_TIMESTAMP] <= stop_timestamp
        res_mask = start_mask == stop_mask
        self.clipped_analyzer_data_data = self.analyzer_data_data[res_mask].copy(deep=True)
        self.clipped_analyzer_data_data.reset_index(drop=True, inplace=True)

        imu_marker_mask = self.clipped_analyzer_data_data[VdrAlkaidSensorsData._DATA_MARKER].str.contains('#IMU')
        self.clipped_analyzer_imu_data_data = self.clipped_analyzer_data_data[imu_marker_mask].copy(deep=True)
        self.clipped_analyzer_imu_data_data.reset_index(drop=True, inplace=True)

        self.data_data_row_counts = self.clipped_analyzer_imu_data_data.shape[0]
        self.data_data_start_timestamp = self.clipped_analyzer_imu_data_data.loc[0, VdrAlkaidSensorsData._DATA_POS_TIMESTAMP]
        self.data_data_stop_timestamp = self.clipped_analyzer_imu_data_data.loc[self.data_data_row_counts - 1, VdrAlkaidSensorsData._DATA_POS_TIMESTAMP]

    def save_clipped_data(self):
        imu_data_file_name = 'VdrExperimentAlkaidIMUDataClipped.csv'
        imu_data_file_path = os.path.join(self.folder_path, imu_data_file_name)
        self.clipped_analyzer_imu_data_data.to_csv(
            imu_data_file_path,
            float_format='%17.13f',
            header=False,
            index=False
        )

        fusion_data_file_name = 'VdrExperimentAlkaidFusionDataClipped.csv'
        fusion_data_file_path = os.path.join(self.folder_path, fusion_data_file_name)
        write_fusion_data = self.clipped_analyzer_pos_data.copy(deep=True)
        write_fusion_data.reset_index(drop=True, inplace=True)
        # write_fusion_data[self._POS_TIMESTAMP] = write_fusion_data[self._POS_TIMESTAMP]
        write_fusion_data.to_csv(
            fusion_data_file_path,
            float_format='%17.13f',
            header=False,
            index=False
        )
