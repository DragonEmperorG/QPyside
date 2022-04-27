from enum import Enum, auto


# https://code.qt.io/cgit/qt/qtcharts.git/tree/src/chartsqml2/declarativechart_p.h#n105
class ChartViewSeriesType(Enum):
    SeriesTypeLine = 0
    SeriesTypeArea = auto()
    SeriesTypeBar = auto()
    SeriesTypeStackedBar = auto()
    SeriesTypePercentBar = auto()
    SeriesTypePie = auto()
    SeriesTypeScatter = auto()
    SeriesTypeSpline = auto()
    SeriesTypeHorizontalBar = auto()
    SeriesTypeHorizontalStackedBar = auto()
    SeriesTypeHorizontalPercentBar = auto()
    SeriesTypeBoxPlot = auto()
    SeriesTypeCandlestick = auto()


