import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class ColumnChartPage extends StatefulWidget {
  @override
  _ColumnChartPageState createState() => _ColumnChartPageState();
}

class _ColumnChartPageState extends State<ColumnChartPage> {
  late List<ChartColumnData> data; // Renamed _ChartData to ChartColumnData

  @override
  void initState() {
    super.initState();

    // Updated variable names and removed conflicts
    data = [
      ChartColumnData('Jan', 0, Color(0xFF4318FF)),
      ChartColumnData('Feb', 0, Color(0xFF4318FF)),
      ChartColumnData('Mar', 0, Color(0xFF4318FF)),
      ChartColumnData('Apr', 10, Color(0xFF4318FF)),
      ChartColumnData('May', 12, Color(0xFF4318FF)),
      ChartColumnData('Jun', 19, Color(0xFF4318FF)),
      ChartColumnData('Jul', 32, Color(0xFF4318FF)),
      ChartColumnData('Aug', 40, Color(0xFF4318FF)),
      ChartColumnData('Sep', 45, Color(0xFF4318FF)),
      ChartColumnData('Oct', 80, Color(0xFF4318FF)),
      ChartColumnData('Nov', 65, Color(0xFF4318FF)),
      ChartColumnData('Dec', 120, Color(0xFF4318FF)),
    ];

  }

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: SfCartesianChart(
        // title: ChartTitle(text: 'Monthly files Data'),
        backgroundColor: Colors.white,
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: 'number of fils uploded'),
        ),
        series: <CartesianSeries<ChartColumnData, String>>[
          ColumnSeries<ChartColumnData, String>(
            dataSource: data,
            xValueMapper: (ChartColumnData data, _) => data.month,
            yValueMapper: (ChartColumnData data, _) => data.sales,
            pointColorMapper: (ChartColumnData data, _) => data.color,
            width: 0.4,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5) ,topRight:  Radius.circular(5)),
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// Renamed _ChartData to ChartColumnData to avoid naming conflicts
class ChartColumnData {
  final String month;
  final double sales;
  final Color color;

  ChartColumnData(this.month, this.sales, this.color);
}
