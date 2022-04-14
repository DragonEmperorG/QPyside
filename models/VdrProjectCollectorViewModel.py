from PySide2.QtCore import QAbstractListModel, Qt, QModelIndex, QByteArray


class VdrProjectCollectorViewModel(QAbstractListModel):
    NameRole = Qt.UserRole + 1
    TypeRole = Qt.UserRole + 2
    CountsRole = Qt.UserRole + 3
    StartTimestampRole = Qt.UserRole + 4
    StopTimestampRole = Qt.UserRole + 5

    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.vdrProjectViewItemList = []

    def rowCount(self, parent=QModelIndex()):
        return len(self.vdrProjectViewItemList)

    def roleNames(self):
        default = super().roleNames()
        default[self.NameRole] = QByteArray(b"name")
        default[self.TypeRole] = QByteArray(b"type")
        default[self.CountsRole] = QByteArray(b"counts")
        default[self.StartTimestampRole] = QByteArray(b"start_timestamp")
        default[self.StopTimestampRole] = QByteArray(b"stop_timestamp")
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
        elif role == self.CountsRole:
            ret = self.vdrProjectViewItemList[index.row()].counts
        elif role == self.StartTimestampRole:
            ret = self.vdrProjectViewItemList[index.row()].start_timestamp
        elif role == self.StopTimestampRole:
            ret = self.vdrProjectViewItemList[index.row()].stop_timestamp
        else:
            ret = None
        return ret

    def setup_model_data(self, item_list):
        self.vdrProjectViewItemList = item_list
        # https://www.pythonguis.com/tutorials/pyside-modelview-architecture/
        self.layoutChanged.emit()

    def clear_model_data(self):
        self.vdrProjectViewItemList = []
