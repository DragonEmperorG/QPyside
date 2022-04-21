import pandas as pd
from PySide2.QtPositioning import QGeoCoordinate

from utils.VdrFileUtils import unix_ms_timestamp_parser, alkaid_timestamp_parser


class VdrPhoneSensorsData:

    _DATA_TIMESTAMP = 'DATA_TIMESTAMP'
    _ACCELEROMETER_X = 'ACCELEROMETER_X'
    _ACCELEROMETER_Y = 'ACCELEROMETER_Y'
    _ACCELEROMETER_Z = 'ACCELEROMETER_Z'
    _GYROSCOPE_X = 'GYROSCOPE_X'
    _GYROSCOPE_Y = 'GYROSCOPE_Y'
    _GYROSCOPE_Z = 'GYROSCOPE_Z'
    _GAME_ROTATION_VECTOR_X = 'GAME_ROTATION_VECTOR_X'
    _GAME_ROTATION_VECTOR_Y = 'GAME_ROTATION_VECTOR_Y'
    _GAME_ROTATION_VECTOR_Z = 'GAME_ROTATION_VECTOR_Z'
    _GAME_ROTATION_VECTOR_SCALAR = 'GAME_ROTATION_VECTOR_SCALAR'
    _ROTATION_VECTOR_X = 'ROTATION_VECTOR_X'
    _ROTATION_VECTOR_Y = 'ROTATION_VECTOR_Y'
    _ROTATION_VECTOR_Z = 'ROTATION_VECTOR_Z'
    _ROTATION_VECTOR_SCALAR = 'ROTATION_VECTOR_SCALAR'
    _GYROSCOPE_UNCALIBRATED_X = 'GYROSCOPE_UNCALIBRATED_X'
    _GYROSCOPE_UNCALIBRATED_Y = 'GYROSCOPE_UNCALIBRATED_Y'
    _GYROSCOPE_UNCALIBRATED_Z = 'GYROSCOPE_UNCALIBRATED_Z'
    _ORIENTATION_X = 'ORIENTATION_X'
    _ORIENTATION_Y = 'ORIENTATION_Y'
    _ORIENTATION_Z = 'ORIENTATION_Z'
    _MAGNETIC_FIELD_X = 'MAGNETIC_FIELD_X'
    _MAGNETIC_FIELD_Y = 'MAGNETIC_FIELD_Y'
    _MAGNETIC_FIELD_Z = 'MAGNETIC_FIELD_Z'
    _GRAVITY_X = 'GRAVITY_X'
    _GRAVITY_Y = 'GRAVITY_Y'
    _GRAVITY_Z = 'GRAVITY_Z'
    _LINEAR_ACCELERATION_X = 'LINEAR_ACCELERATION_X'
    _LINEAR_ACCELERATION_Y = 'LINEAR_ACCELERATION_Y'
    _LINEAR_ACCELERATION_Z = 'LINEAR_ACCELERATION_Z'
    _PRESSURE = 'PRESSURE'
    _GNSS_TIMESTAMP = 'GNSS_TIMESTAMP'
    _GNSS_LONGITUDE = 'GNSS_LONGITUDE'
    _GNSS_LATITUDE = 'GNSS_LATITUDE'
    _GNSS_ACCURACY = 'GNSS_ACCURACY'
    _ALKAID_REQUEST_TIMESTAMP = 'ALKAID_REQUEST_TIMESTAMP'
    _ALKAID_RESPONSIVE_TIMESTAMP = 'ALKAID_RESPONSIVE_TIMESTAMP'
    _ALKAID_STATUS = '_ALKAID_STATUS'
    _ALKAID_TIME = '_ALKAID_TIME'
    _ALKAID_LONGITUDE = 'ALKAID_LONGITUDE'
    _ALKAID_LATITUDE = 'ALKAID_LATITUDE'
    _ALKAID_HEIGHT = 'ALKAID_HEIGHT'
    _ALKAID_AZIMUTH = 'ALKAID_AZIMUTH'
    _ALKAID_SPEED = 'ALKAID_SPEED'
    _ALKAID_AGE = 'ALKAID_AGE'
    _ALKAID_SATSNUM = 'ALKAID_SATSNUM'
    _ALKAID_ACCURACY = 'ALKAID_ACCURACY'
    _VDR_PHONE_SENORS_DATA_NAMES_LIST = [
        _DATA_TIMESTAMP,
        _ACCELEROMETER_X,
        _ACCELEROMETER_Y,
        _ACCELEROMETER_Z,
        _GYROSCOPE_X,
        _GYROSCOPE_Y,
        _GYROSCOPE_Z,
        _GAME_ROTATION_VECTOR_X,
        _GAME_ROTATION_VECTOR_Y,
        _GAME_ROTATION_VECTOR_Z,
        _GAME_ROTATION_VECTOR_SCALAR,
        _ROTATION_VECTOR_X,
        _ROTATION_VECTOR_Y,
        _ROTATION_VECTOR_Z,
        _ROTATION_VECTOR_SCALAR,
        _GYROSCOPE_UNCALIBRATED_X,
        _GYROSCOPE_UNCALIBRATED_Y,
        _GYROSCOPE_UNCALIBRATED_Z,
        _ORIENTATION_X,
        _ORIENTATION_Y,
        _ORIENTATION_Z,
        _MAGNETIC_FIELD_X,
        _MAGNETIC_FIELD_Y,
        _MAGNETIC_FIELD_Z,
        _GRAVITY_X,
        _GRAVITY_Y,
        _GRAVITY_Z,
        _LINEAR_ACCELERATION_X,
        _LINEAR_ACCELERATION_Y,
        _LINEAR_ACCELERATION_Z,
        _PRESSURE,
        _GNSS_TIMESTAMP,
        _GNSS_LONGITUDE,
        _GNSS_LATITUDE,
        _GNSS_ACCURACY,
        _ALKAID_REQUEST_TIMESTAMP,
        _ALKAID_RESPONSIVE_TIMESTAMP,
        _ALKAID_STATUS,
        _ALKAID_TIME,
        _ALKAID_LONGITUDE,
        _ALKAID_LATITUDE,
        _ALKAID_HEIGHT,
        _ALKAID_AZIMUTH,
        _ALKAID_SPEED,
        _ALKAID_AGE,
        _ALKAID_SATSNUM,
        _ALKAID_ACCURACY
    ]

    def __init__(self, phone_name, path):
        self.alkaid_polyline_path = None
        self.gnss_polyline_path = None

        phone_collector_raw_data = pd.read_csv(
            path,
            names=VdrPhoneSensorsData._VDR_PHONE_SENORS_DATA_NAMES_LIST
        )

        phone_collector_analyzer_data = phone_collector_raw_data.copy(deep=True)
        phone_collector_analyzer_data[VdrPhoneSensorsData._DATA_TIMESTAMP] = phone_collector_analyzer_data[VdrPhoneSensorsData._DATA_TIMESTAMP].map(unix_ms_timestamp_parser)
        phone_collector_analyzer_data[VdrPhoneSensorsData._GNSS_TIMESTAMP] = phone_collector_analyzer_data[VdrPhoneSensorsData._GNSS_TIMESTAMP].map(unix_ms_timestamp_parser)
        phone_collector_analyzer_data[VdrPhoneSensorsData._ALKAID_REQUEST_TIMESTAMP] = phone_collector_analyzer_data[VdrPhoneSensorsData._ALKAID_REQUEST_TIMESTAMP].map(unix_ms_timestamp_parser)
        phone_collector_analyzer_data[VdrPhoneSensorsData._ALKAID_RESPONSIVE_TIMESTAMP] = phone_collector_analyzer_data[VdrPhoneSensorsData._ALKAID_RESPONSIVE_TIMESTAMP].map(unix_ms_timestamp_parser)
        phone_collector_analyzer_data[VdrPhoneSensorsData._ALKAID_TIME] = phone_collector_analyzer_data[VdrPhoneSensorsData._ALKAID_TIME].map(alkaid_timestamp_parser)

        self.phone_name = phone_name
        self.raw_csv_data = phone_collector_raw_data
        self.analyzer_data = phone_collector_analyzer_data
        self.clipped_analyzer_data = phone_collector_analyzer_data
        self.row_counts = self.raw_csv_data.shape[0]
        self.start_timestamp = self.analyzer_data.loc[0, VdrPhoneSensorsData._ALKAID_TIME]
        self.stop_timestamp = self.analyzer_data.loc[self.row_counts - 1, VdrPhoneSensorsData._ALKAID_TIME]

    def clip_data(self, start_timestamp, stop_timestamp):
        start = self.analyzer_data[VdrPhoneSensorsData._ALKAID_TIME] >= start_timestamp
        stop = self.analyzer_data[VdrPhoneSensorsData._ALKAID_TIME] <= stop_timestamp
        res = start == stop
        self.clipped_analyzer_data = self.analyzer_data[res].copy(deep=True)
        self.clipped_analyzer_data.reset_index(drop=True, inplace=True)

        self.row_counts = self.clipped_analyzer_data.shape[0]
        self.start_timestamp = self.clipped_analyzer_data.loc[0, VdrPhoneSensorsData._ALKAID_TIME]
        self.stop_timestamp = self.clipped_analyzer_data.loc[self.row_counts - 1, VdrPhoneSensorsData._ALKAID_TIME]

        clipped_analyzer_alkaid_data_coordinate_series = self.clipped_analyzer_data.apply(
            lambda row: QGeoCoordinate(row.ALKAID_LATITUDE, row.ALKAID_LONGITUDE),
            axis=1
        )
        self.alkaid_polyline_path = clipped_analyzer_alkaid_data_coordinate_series.tolist()

        clipped_analyzer_gnss_data_coordinate_series = self.clipped_analyzer_data.apply(
            lambda row: QGeoCoordinate(row.GNSS_LATITUDE, row.GNSS_LONGITUDE),
            axis=1
        )
        self.gnss_polyline_path = clipped_analyzer_gnss_data_coordinate_series.tolist()
