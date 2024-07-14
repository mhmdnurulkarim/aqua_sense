import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

var currentDate = DateTime.now();
var currentDateFormatted =
    "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
var dayOfWeek = getDayOfWeek(currentDate.weekday);

String getDayOfWeek(int weekday) {
  switch (weekday) {
    case 1:
      return 'senin';
    case 2:
      return 'selasa';
    case 3:
      return 'rabu';
    case 4:
      return 'kamis';
    case 5:
      return 'jumat';
    case 6:
      return 'sabtu';
    case 7:
      return 'minggu';
    default:
      return 'minggu';
  }
}

class WeeklyData {
  final double doAverage;
  final double phAverage;

  WeeklyData(this.doAverage, this.phAverage);

  String get doAverageFormatted => doAverage.toStringAsFixed(2);
  String get phAverageFormatted => phAverage.toStringAsFixed(2);
}

class DailyData {
  final double doAverage;
  final double phAverage;

  DailyData(this.doAverage, this.phAverage);
}

Widget leftTitles(double value, TitleMeta meta) {
  if (value % 2 == 0 && value <= 20) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
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

BarChartGroupData makeGroupData(int x, double y1, double y2) {
  return BarChartGroupData(
    barsSpace: 4,
    x: x,
    barRods: [
      BarChartRodData(
        toY: y1,
        color: Colors.amber,
        width: 7,
      ),
      BarChartRodData(
        toY: y2,
        color: Colors.indigo,
        width: 7,
      ),
    ],
  );
}
