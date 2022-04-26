# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys

from PySide2.QtQml import QQmlApplicationEngine, qmlRegisterType
from PySide2.QtQuickControls2 import QQuickStyle
from PySide2.QtWidgets import QApplication

from models.VdrProjectViewModelProvider import VdrProjectViewModelProvider

if __name__ == "__main__":
    # https://stackoverflow.com/questions/57514937/qml-charts-causes-crash-on-startup
    app = QApplication(sys.argv)
    QQuickStyle.setStyle("Material")

    qmlRegisterType(
        VdrProjectViewModelProvider,
        'VdrProjectViewModelProvider',
        1,
        0,
        'VdrProjectViewModelProvider'
    )

    engine = QQmlApplicationEngine()
    engine.load(os.fspath(Path(__file__).resolve().parent / "qml" / "MainWindow.qml"))
    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())
