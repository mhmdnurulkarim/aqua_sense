import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../widgets/widget_utils.dart';

class CustomBarChart extends StatelessWidget {
  final List<DataPoint> dataPoint;
  final List<String> bottomTitles;

  CustomBarChart({required this.dataPoint, required this.bottomTitles});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 12),
            Expanded(
              child: _buildBarChart(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  BarChart _buildBarChart() {
    return BarChart(
      BarChartData(
        maxY: 20,
        barTouchData: _buildBarTouchData(),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(show: false),
        barGroups: _generateDailyBarGroups(),
        gridData: const FlGridData(show: false),
      ),
    );
  }

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            rod.toY.toString(),
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
      touchCallback: (FlTouchEvent event, BarTouchResponse? response) {},
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) =>
              _bottomTitles(value, meta, bottomTitles),
          reservedSize: 42,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          interval: 2,
          getTitlesWidget: _leftTitles,
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateDailyBarGroups() {
    return List.generate(dataPoint.length, (i) {
      final daily = dataPoint[i];
      return BarChartGroupData(
        barsSpace: 4,
        x: i,
        barRods: [
          BarChartRodData(
            toY: daily.doAverage,
            color: Colors.amber,
            width: 7,
          ),
          BarChartRodData(
            toY: daily.phAverage,
            color: Colors.indigo,
            width: 7,
          ),
        ],
      );
    });
  }

  Widget _bottomTitles(double value, TitleMeta meta, List<String> titles) {
    final index = value.toInt();
    if (index < 0 || index >= titles.length) {
      return Container();
    }
    final title = titles[index];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _leftTitles(double value, TitleMeta meta) {
    if (value <= 20) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 8,
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(
            color: Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
