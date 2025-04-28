import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChartPage extends StatefulWidget {
  @override
  _DoughnutChartPageState createState() => _DoughnutChartPageState();
}

class _DoughnutChartPageState extends State<DoughnutChartPage> {
  late List<_ChartData> data;

  @override
  void initState() {
    super.initState();
    data = [
      _ChartData('.pdf', 35, Color(0xFF4318FF)),
      _ChartData('.image', 20, Color(0xFFEFF4FB)),
      _ChartData('.word', 45, Color(0xFF6AD2FF)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfCircularChart(
          backgroundColor: Colors.white,
          title: ChartTitle(text: 'Type de documents'),
          legend: Legend(isVisible: true,position: LegendPosition.bottom,  orientation: LegendItemOrientation.horizontal),
          series: <CircularSeries>[
            DoughnutSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (_ChartData data, _) => data.category,
              yValueMapper: (_ChartData data, _) => data.value,
              pointColorMapper: (_ChartData data, _) => data.color, // Custom colors
              dataLabelSettings: DataLabelSettings(isVisible: true), // Show labels
            ),
          ],
        ),
    );
  }
}

// Data class for the chart
class _ChartData {
  _ChartData(this.category, this.value, this.color);

  final String category;
  final double value;
  final Color color;
}
