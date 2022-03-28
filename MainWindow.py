# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine, qmlRegisterType
from PySide2.QtQuickControls2 import QQuickStyle

from models.VdrProject import VdrProject

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    QQuickStyle.setStyle("Material")
    engine = QQmlApplicationEngine()

    qmlRegisterType(VdrProject, "VdrProject", 1, 0, "VdrProject")

    engine.load(os.fspath(Path(__file__).resolve().parent / "MainWindow.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
