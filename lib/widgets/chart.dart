import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:karamba_warning/widgets/widget_utils.dart';

class TodayChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodayChartState();
}

class TodayChartState extends State<TodayChart> {
  late List<BarChartGroupData> showingBarGroups;
  int touchedGroupIndex = -1;
  List<String> titlesList = [];

  @override
  void initState() {
    super.initState();
    // Initialize showingBarGroups with an empty list
    showingBarGroups = [];

    // Fetch data from Firebase and populate showingBarGroups
    firebaseData();
  }

  void firebaseData() async {
    DateTime currentDate = DateTime.now();
    var currentDateFormatted =
        "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
    String dayOfWeek = getDayOfWeek(currentDate.weekday);

    // Fetch data from Firebase
    // var querySnapshot = await FirebaseFirestore.instance
    //     .collection('history')
    //     .doc(currentDateFormatted)
    //     .collection(dayOfWeek)
    //     .get();

    var querySnapshot = await FirebaseFirestore.instance
        .collection('history')
        .doc("2024-05-08")
        .collection("rabu")
        .get();

    // Process fetched data
    var barGroups = <BarChartGroupData>[];
    var fetchedTitles = <String>[];
    querySnapshot.docs.forEach((doc) {
      var doValue = doc['DO'] != null ? doc['DO'].toDouble() : 0;
      var phValue = doc['pH'] != null ? doc['pH'].toDouble() : 0;
      var time = doc['Jam'] != null ? doc['Jam'].toString() : '';
      var barGroup = makeGroupData(barGroups.length, doValue, phValue);
      if (time.length >= 5) {
        time = time.substring(0, 5); // Extract HH:mm from the string
      }
      barGroups.add(barGroup);
      fetchedTitles.add(time);
    });

    setState(() {
      showingBarGroups = barGroups;
      titlesList = fetchedTitles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 20,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: ((group) {
                        return Colors.grey;
                      }),
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {},
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= titlesList.length) {
      return Container();
    }

    final text = Text(
      titlesList[index],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }
}