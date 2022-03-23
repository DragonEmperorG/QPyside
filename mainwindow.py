# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys

from PySide6.QtWidgets import QApplication, QMainWindow
from PySide6.QtCore import QFile, QIODevice
from PySide6.QtUiTools import QUiLoader


class MainWindow(QMainWindow):
    def __init__(self):
        super(MainWindow, self).__init__()
        self.load_ui()

    def load_ui(self):
        ui_file_name = "mainwindow.ui"
        ui_path = os.fspath(Path(__file__).resolve().parent / ui_file_name)
        ui_file = QFile(ui_path)
        if not ui_file.open(QIODevice.ReadOnly):
            print(f"Cannot open {ui_file_name}: {ui_file.errorString()}")
            sys.exit(-1)
        ui_loader = QUiLoader()
        ui_main_window = ui_loader.load(ui_file, self)
        ui_file.close()
        if not ui_main_window:
            print(ui_loader.errorString())
            sys.exit(-1)
        ui_main_window.show()


if __name__ == "__main__":
    app = QApplication([])
    main_window = MainWindow()
    sys.exit(app.exec())
