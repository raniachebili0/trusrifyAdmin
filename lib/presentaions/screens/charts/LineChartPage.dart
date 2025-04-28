import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartPage extends StatefulWidget {
  @override
  _LineChartPageState createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  // Sample data for the line chart
  late List<_ChartData> data;

  @override
  void initState() {
    super.initState();
    // Populate the data for the chart
    data = [
      _ChartData('Jan', 2),
      _ChartData('Feb', 14),
      _ChartData('Mar', 15),
      _ChartData('Apr', 20),
      _ChartData('May', 25),
      _ChartData('Jun', 19),
      _ChartData('Jul', 30),
      _ChartData('Aug', 35),
      _ChartData('Sep', 12),
      _ChartData('Oct', 75),
      _ChartData('Nov', 50),
      _ChartData('Dec', 95),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfCartesianChart(
          backgroundColor: Colors.white,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'number of users added'),
          ),
          series: <CartesianSeries<_ChartData, String>>[
            LineSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (_ChartData sales, _) => sales.month,
              yValueMapper: (_ChartData sales, _) => sales.sales,
              color: Colors.blue,  // Color of the line
              width: 2,  // Line width
              markerSettings: MarkerSettings(isVisible: true), // Show markers on the line
            ),
          ],
        ),
    );
  }
}

// Data class for chart
class _ChartData {
  _ChartData(this.month, this.sales);

  final String month;
  final double sales;
}
