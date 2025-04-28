import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartPage extends StatefulWidget {
  @override
  _PieChartPageState createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  late List<_ChartData> data;

  @override
  void initState() {
    data = [
      _ChartData('Users did commit fraud', 35,Color(0xFF4318FF)),
      _ChartData('Users did not commit fraud', 25, Color(0xFF6AD2FF)),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: SfCircularChart(
        backgroundColor: Colors.white,
        title: ChartTitle(text: 'Fraude by Users'),
        legend: Legend(isVisible: true,position: LegendPosition.bottom,  orientation: LegendItemOrientation.vertical),
        series: <PieSeries<_ChartData, String>>[
          PieSeries<_ChartData, String>(
            dataSource: data,
            xValueMapper: (_ChartData data, _) => data.category,
            yValueMapper: (_ChartData data, _) => data.value,
            pointColorMapper: (_ChartData data, _) => data.color,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  final String category;
  final double value;
  final Color color;

  _ChartData(this.category, this.value, this.color);
}