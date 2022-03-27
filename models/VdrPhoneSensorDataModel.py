from PySide2.QtCore import QAbstractListModel


class VdrPhoneSensorDataModel(QAbstractListModel):
    def __init__(self):
        super(VdrPhoneSensorDataModel, self).__init__()
        self.name = 1
