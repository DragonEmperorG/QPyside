from PySide2.QtCore import QAbstractListModel, Qt, QModelIndex, QByteArray


class VdrProjectMapViewPolylineModel(QAbstractListModel):
    PolylineDataRole = Qt.UserRole + 1

    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.vdrProjectMapViewPolylineItemList = []

    def rowCount(self, parent=QModelIndex(), **kwargs):
        return len(self.vdrProjectMapViewPolylineItemList)

    def roleNames(self):
        default = super().roleNames()
        default[self.PolylineDataRole] = QByteArray(b"polylineData")
        return default

    def data(self, index, role):
        if not self.vdrProjectMapViewPolylineItemList:
            ret = None
        elif not index.isValid():
            ret = None
        elif role == self.PolylineDataRole:
            ret = self.vdrProjectMapViewPolylineItemList[index.row()].polylineData
        else:
            ret = None
        return ret

    def setup_model_data(self, item_list):
        self.vdrProjectMapViewPolylineItemList = item_list
        # https://www.pythonguis.com/tutorials/pyside-modelview-architecture/
        self.layoutChanged.emit()

    def clear_model_data(self):
        self.vdrProjectMapViewPolylineItemList = []
