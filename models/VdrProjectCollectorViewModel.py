import os

from pathlib import Path

from PySide2.QtCore import Slot, QAbstractListModel, Qt, QModelIndex, QObject, QByteArray

from models.VdrAlkaidSensorsData import VdrAlkaidSensorsData
from models.VdrPhoneSensorsData import VdrPhoneSensorsData
from models.VdrProject import VdrProject
from models.VdrProjectViewItem import VdrProjectViewItem


class VdrProjectCollectorViewModel(QAbstractListModel):
    NameRole = Qt.UserRole + 1
    TypeRole = Qt.UserRole + 2

    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.vdrProjectViewItemList = []

    def rowCount(self, parent=QModelIndex()):
        return len(self.vdrProjectViewItemList)

    def roleNames(self):
        default = super().roleNames()
        default[self.NameRole] = QByteArray(b"name")
        default[self.TypeRole] = QByteArray(b"type")
        return default

    def data(self, index, role):
        if not self.vdrProjectViewItemList:
            ret = None
        elif not index.isValid():
            ret = None
        elif role == self.NameRole:
            ret = self.vdrProjectViewItemList[index.row()].name
        elif role == self.TypeRole:
            ret = self.vdrProjectViewItemList[index.row()].type
        else:
            ret = None
        return ret

    def setup_model_data(self, item_list):
        self.vdrProjectViewItemList = item_list
        # https://www.pythonguis.com/tutorials/pyside-modelview-architecture/
        self.layoutChanged.emit()

    def clear_model_data(self):
        self.vdrProjectViewItemList = []
