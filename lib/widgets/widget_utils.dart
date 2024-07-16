import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //TodayScreen
  Future<DailyData> fetchDailyData(DateTime currentDate) async {
    var currentDateFormatted =
        "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
    String dayOfWeek = getDayOfWeek(currentDate.weekday);

    var querySnapshot = await _firestore
        .collection('history')
        .doc(currentDateFormatted)
        .collection(dayOfWeek)
        .get();

    double dailyDoSum = 0;
    double dailyPhSum = 0;
    var docs = querySnapshot.docs;
    int dataCount = querySnapshot.docs.length;

    for (var doc in docs) {
      dailyDoSum += doc['DO'];
      dailyPhSum += doc['pH'];
    }

    return dataCount > 0 ? DailyData(dailyDoSum, dailyPhSum) : DailyData(0, 0);
  }

//WeeklyScreen
  Future<List<DailyData>> getDailyData(int weekNumber) async {
    List<DailyData> dailyData = [];
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    DateTime firstDayOfMonth = DateTime(now.year, currentMonth, 1);
    DateTime lastDayOfMonth = DateTime(now.year, currentMonth + 1, 0);

    DateTime startOfWeek =
    firstDayOfMonth.add(Duration(days: (weekNumber - 1) * 7));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    if (endOfWeek.month != currentMonth) {
      endOfWeek = lastDayOfMonth;
    }

    List<Future<DailyData>> dailyDataFutures = [];
    for (int day = 0; day < 7; day++) {
      DateTime currentDate = startOfWeek.add(Duration(days: day));
      if (currentDate.month != currentMonth || currentDate.isAfter(endOfWeek))
        break;
      dailyDataFutures.add(fetchDailyData(currentDate));
    }

    dailyData = await Future.wait(dailyDataFutures);
    return dailyData;
  }

  //ThisMonthScreen
  Future<List<WeeklyData>> getWeeklyData() async {
    List<WeeklyData> weeklyData = [];
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    DateTime firstDayOfMonth = DateTime(now.year, currentMonth, 1);

    for (int week = 0; week < 4; week++) {
      DateTime startOfWeek = firstDayOfMonth.add(Duration(days: week * 7));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
      if (endOfWeek.month != currentMonth) {
        endOfWeek = DateTime(now.year, currentMonth + 1, 0);
      }

      List<Future<DailyData>> dailyDataFutures = [];
      for (int day = 0; day < 7; day++) {
        DateTime currentDate = startOfWeek.add(Duration(days: day));
        if (currentDate.month != currentMonth) break;
        dailyDataFutures.add(fetchDailyData(currentDate));
      }

      List<DailyData> dailyDataList = await Future.wait(dailyDataFutures);
      if (dailyDataList.isNotEmpty) {
        double weeklyDoSum =
        dailyDataList.map((d) => d.doAverage).reduce((a, b) => a + b);
        double weeklyPhSum =
        dailyDataList.map((d) => d.phAverage).reduce((a, b) => a + b);
        weeklyData.add(WeeklyData(weeklyDoSum / dailyDataList.length,
            weeklyPhSum / dailyDataList.length));
      } else {
        weeklyData.add(WeeklyData(0, 0));
      }
    }

    return weeklyData;
  }
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
