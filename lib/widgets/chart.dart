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

class WeeklyChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WeeklyChartState();
}

class WeeklyChartState extends State<WeeklyChart> {
  final double width = 7;
  late List<BarChartGroupData> showingBarGroups;
  int touchedGroupIndex = -1;
  List<String> titles = [];

  @override
  void initState() {
    super.initState();
    // Initialize showingBarGroups with an empty list
    showingBarGroups = [];
    // Fetch data from Firebase and populate showingBarGroups
    fetchWeeklyData();
  }

  void fetchWeeklyData() async {
    var currentDate = DateTime.now();
    var endDate = currentDate.subtract(Duration(days: currentDate.weekday - 1)); // Start from Monday
    var startDate = endDate.subtract(Duration(days: 6)); // Previous 6 days

    var startFormatted =
        "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
    var endFormatted =
        "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

    // Fetch data from Firestore
    var querySnapshot = await FirebaseFirestore.instance
        .collection('history')
        .where('date', isGreaterThanOrEqualTo: startFormatted)
        .where('date', isLessThanOrEqualTo: endFormatted)
        .get();

    // Process fetched data
    var barGroups = <BarChartGroupData>[];
    var fetchedTitles = <String>[];

    // Initialize data for each day of the week
    for (var i = 0; i < 7; i++) {
      var day = startDate.add(Duration(days: i));
      var dayOfWeek = getDayOfWeek(day.weekday);
      var data = querySnapshot.docs.firstWhere(
            (doc) => doc['date'] == "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}",
      );

      if (data != null) {
        var doValue = data['DO'] != null ? data['DO'].toDouble() : 0;
        var phValue = data['pH'] != null ? data['pH'].toDouble() : 0;

        // Create BarChartGroupData object
        var barGroup = makeGroupData(i, doValue, phValue);
        barGroups.add(barGroup);
        fetchedTitles.add(dayOfWeek);
      } else {
        // If no data found for the day, add empty data
        var barGroup = makeGroupData(i, 0, 0);
        barGroups.add(barGroup);
        fetchedTitles.add(dayOfWeek);
      }
    }

    setState(() {
      showingBarGroups = barGroups;
      titles = fetchedTitles;
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
                  maxY: 14,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.toString(),
                          TextStyle(color: Colors.white),
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      // Your touch callback logic here
                    },
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
                    show: true,
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

  Widget leftTitles(double value, TitleMeta meta) {
    if (value % 2 == 0 && value <= 14) {
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

  Widget bottomTitles(double value, TitleMeta meta) {
    var index = value.toInt();
    if (index >= 0 && index < titles.length) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 16,
        child: Text(
          titles[index],
          style: const TextStyle(
            color: Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
    }
    return Container();
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.amber,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.indigo,
          width: width,
        ),
      ],
    );
  }
}