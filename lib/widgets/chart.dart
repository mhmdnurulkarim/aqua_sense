import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/data_service.dart';

class CustomLineChart extends StatelessWidget {
  final List<DataPoint> dataPoint;
  final List<String> bottomTitles;

  CustomLineChart({required this.dataPoint, required this.bottomTitles});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 12),
            Expanded(
              child: _buildChart(),
            ),
          ],
        ),
      ),
    );
  }

  LineChart _buildChart() {
    return LineChart(
      LineChartData(
        maxY: 20,
        minY: 0,
        lineTouchData: _buildLineTouchData(),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(show: false),
        lineBarsData: _generateLineBarData(),
        gridData: const FlGridData(show: false),
      ),
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((touchedSpot) {
            return LineTooltipItem(
              touchedSpot.y.toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList();
        },
      ),
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

  List<LineChartBarData> _generateLineBarData() {
    List<FlSpot> doSpots = List.generate(dataPoint.length, (i) {
      final daily = dataPoint[i];
      return FlSpot(i.toDouble(), daily.doAverage);
    });

    List<FlSpot> phSpots = List.generate(dataPoint.length, (i) {
      final daily = dataPoint[i];
      return FlSpot(i.toDouble(), daily.phAverage);
    });

    return [
      LineChartBarData(
        spots: doSpots,
        isCurved: true,
        color: Colors.amber,
        barWidth: 3,
        belowBarData: BarAreaData(show: false),
      ),
      LineChartBarData(
        spots: phSpots,
        isCurved: true,
        color: Colors.indigo,
        barWidth: 3,
        belowBarData: BarAreaData(show: false),
      ),
    ];
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
    if (value % 2 == 0 && value <= 20) {
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
