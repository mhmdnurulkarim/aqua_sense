import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const padding8 = EdgeInsets.all(8);
const padding10 = EdgeInsets.only(left: 10);
const textStyleBoldWhite = TextStyle(color: Colors.white);

String getDayOfWeek(int weekday) {
  switch (weekday) {
    case 0:
      return 'minggu';
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
    default:
      return 'minggu';
  }
}

class DataPoint {
  final double doAverage;
  final double phAverage;
  final String titleToday;

  DataPoint(this.doAverage, this.phAverage, this.titleToday);
}

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //TodayScreen
  Future<List<DataPoint>> getTodayData() async {
    DateTime currentDate = DateTime.now();
    // DateTime currentDate = DateTime(2024, 7, 13);
    var currentDateFormatted =
        "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
    String dayOfWeek = getDayOfWeek(currentDate.weekday);

    var querySnapshot = await _firestore
        .collection('history')
        .doc(currentDateFormatted)
        .collection(dayOfWeek)
        .get();

    List<DataPoint> todayData = [];
    double todayDo = 0;
    double todayPh = 0;
    String titleToday = "";
    int dataCount = querySnapshot.docs.length;

    if (dataCount > 0) {
      querySnapshot.docs.forEach((doc) {
        todayDo = doc['DO'] != null ? doc['DO'].toDouble() : 0;
        todayPh = doc['pH'] != null ? doc['pH'].toDouble() : 0;
        titleToday = doc['Jam'] != null ? doc['Jam'].toString() : '';
        if (titleToday.length >= 5) {
          titleToday =
              titleToday.substring(0, 5); // Extract HH:mm from the string
        }

        todayData.add(DataPoint(todayDo, todayPh, titleToday));
      });
    }

    return todayData;
  }

  //Fetch Data Weekly & This Month
  Future<DataPoint> fetchDailyData(DateTime currentDate) async {
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
    int dataCount = querySnapshot.docs.length;

    if (dataCount > 0) {
      querySnapshot.docs.forEach((doc) {
        dailyDoSum += doc['DO'] != null ? doc['DO'].toDouble() : 0;
        dailyPhSum += doc['pH'] != null ? doc['pH'].toDouble() : 0;
      });
      return DataPoint(dailyDoSum / dataCount, dailyPhSum / dataCount, "");
    } else {
      return DataPoint(0, 0, "");
    }
  }

//WeeklyScreen
  Future<List<DataPoint>> getDailyData(int weekNumber) async {
    List<DataPoint> dailyData = [];
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

    List<Future<DataPoint>> dailyDataFutures = [];
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
  Future<List<DataPoint>> getWeeklyData() async {
    List<DataPoint> weeklyData = [];
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    DateTime firstDayOfMonth = DateTime(now.year, currentMonth, 1);

    for (int week = 0; week < 4; week++) {
      DateTime startOfWeek = firstDayOfMonth.add(Duration(days: week * 7));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
      if (endOfWeek.month != currentMonth) {
        endOfWeek = DateTime(now.year, currentMonth + 1, 0);
      }

      List<Future<DataPoint>> dailyDataFutures = [];
      for (int day = 0; day < 7; day++) {
        DateTime currentDate = startOfWeek.add(Duration(days: day));
        if (currentDate.month != currentMonth) break;
        dailyDataFutures.add(fetchDailyData(currentDate));
      }

      List<DataPoint> dailyDataList = await Future.wait(dailyDataFutures);
      if (dailyDataList.isNotEmpty) {
        double weeklyDoSum =
            dailyDataList.map((d) => d.doAverage).reduce((a, b) => a + b);
        double weeklyPhSum =
            dailyDataList.map((d) => d.phAverage).reduce((a, b) => a + b);
        weeklyData.add(DataPoint(weeklyDoSum / dailyDataList.length,
            weeklyPhSum / dailyDataList.length, ""));
      } else {
        weeklyData.add(DataPoint(0, 0, ""));
      }
    }

    return weeklyData;
  }
}

//Section Header
class SectionHeader extends StatelessWidget {
  final String text;
  final EdgeInsets padding;

  SectionHeader({required this.text, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: padding,
        child: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// Value Container
class ValueContainer extends StatelessWidget {
  final String label;
  final double value;

  ValueContainer({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 11),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Legend Item
class LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final TextStyle? textStyle;

  LegendItem({required this.label, required this.color, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textStyle ?? TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
