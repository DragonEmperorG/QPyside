from PySide2.QtCore import QAbstractListModel, Qt, QModelIndex, QByteArray, QAbstractItemModel


class VdrProjectCollectorViewModel(QAbstractListModel):
    ItemIndexRole = Qt.UserRole + 1
    NameRole = Qt.UserRole + 2
    TypeRole = Qt.UserRole + 3
    CountsRole = Qt.UserRole + 4
    StartTimestampRole = Qt.UserRole + 5
    StopTimestampRole = Qt.UserRole + 6
    AlkaidPolylineEnableRole = Qt.UserRole + 7

    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.vdrProjectViewItemList = []

    def rowCount(self, parent=QModelIndex()):
        return len(self.vdrProjectViewItemList)

    def roleNames(self):
        default = super().roleNames()
        default[self.ItemIndexRole] = QByteArray(b"item_index")
        default[self.NameRole] = QByteArray(b"name")
        default[self.TypeRole] = QByteArray(b"type")
        default[self.CountsRole] = QByteArray(b"counts")
        default[self.StartTimestampRole] = QByteArray(b"start_timestamp")
        default[self.StopTimestampRole] = QByteArray(b"stop_timestamp")
        default[self.AlkaidPolylineEnableRole] = QByteArray(b"alkaid_polyline_enable")
        return default

    def data(self, index, role):
        if not self.vdrProjectViewItemList:
            return None

        if not index.isValid():
            return None

        vdrProjectViewItem = self.vdrProjectViewItemList[index.row()]

        if role == self.ItemIndexRole:
            ret = vdrProjectViewItem.item_index
        elif role == self.NameRole:
            ret = vdrProjectViewItem.name
        elif role == self.TypeRole:
            ret = vdrProjectViewItem.type
        elif role == self.CountsRole:
            ret = vdrProjectViewItem.counts
        elif role == self.StartTimestampRole:
            ret = vdrProjectViewItem.start_timestamp
        elif role == self.StopTimestampRole:
            ret = vdrProjectViewItem.stop_timestamp
        elif role == self.AlkaidPolylineEnableRole:
            # https://stackoverflow.com/questions/63623566/pyqt-qlistview-checkbox-click-toggle
            if vdrProjectViewItem.alkaid_polyline_enable:
                return Qt.Checked
            else:
                return Qt.Unchecked
        elif role == Qt.CheckStateRole:
            # https://stackoverflow.com/questions/63623566/pyqt-qlistview-checkbox-click-toggle
            if vdrProjectViewItem.alkaid_polyline_enable:
                return Qt.Checked
            else:
                return Qt.Unchecked
        else:
            ret = None
        return ret

    def setup_model_data(self, item_list):
        self.vdrProjectViewItemList = item_list
        # https://www.pythonguis.com/tutorials/pyside-modelview-architecture/
        self.layoutChanged.emit()

    def clear_model_data(self):
        self.vdrProjectViewItemList = []

    # https://doc.qt.io/qtforpython/overviews/model-view-programming.html?highlight=model
    # def flags(self, index):
    #     if not index.isValid():
    #         return None
    #     return Qt.ItemIsEnabled | Qt.ItemIsEditable | Qt.ItemIsSelectable | Qt.ItemIsUserCheckable

    def setData(self, index, value, role):
        if index.isValid():
            row = index
            if role == Qt.CheckStateRole:
                vdrProjectViewItem = self.vdrProjectViewItemList[index.row()]
                vdrProjectViewItem.alkaid_polyline_enable = bool(value)
                self.dataChanged.emit(index, index, (role,))
                print('setData CheckStateRole' + ' ' + str(row) + ' ' + str(value))
                return True
            if role == self.AlkaidPolylineEnableRole:
                vdrProjectViewItem = self.vdrProjectViewItemList[index.row()]
                vdrProjectViewItem.alkaid_polyline_enable = bool(value)
                self.dataChanged.emit(index, index, (role,))
                print('setData AlkaidPolylineEnableRole' + ' ' + str(row) + ' ' + str(value))
                return True
        print('setData' + ' ' + str(index) + ' ' + str(value) + ' ' + str(role))
        return False
