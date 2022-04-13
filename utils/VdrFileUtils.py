import pandas as pd


def unix_ms_timestamp_parser(unix_timestamp):
    return pd.Timestamp(unix_timestamp, unit='ms', tz='Asia/Shanghai')


def unix_s_timestamp_parser(unix_timestamp):
    return pd.Timestamp(unix_timestamp, unit='s', tz='Asia/Shanghai')


def alkaid_timestamp_parser(alkaid_timestamp):
    return pd.Timestamp(alkaid_timestamp, tz='Asia/Shanghai')
