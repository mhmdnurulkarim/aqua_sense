import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:karamba_warning/core/app_export.dart';

import '../widgets/widget_utils.dart';

class ThisMonthScreen extends StatefulWidget {
  @override
  _ThisMonthScreenState createState() => _ThisMonthScreenState();
}

class _ThisMonthScreenState extends State<ThisMonthScreen> {
  final DataService _dataService = DataService();
  List<WeeklyData> _weeklyData = [];

  @override
  void initState() {
    super.initState();
    _fetchWeeklyData();
  }

  Future<void> _fetchWeeklyData() async {
    final data = await _dataService.getWeeklyData();
    setState(() {
      _weeklyData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('Rata-rata Bulan ini'),
                  ),
                ),
                FutureBuilder<List<WeeklyData>>(
                  future: _dataService.getWeeklyData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      double doAvg = snapshot.data!
                              .map((data) => data.doAverage)
                              .reduce((a, b) => a + b) /
                          snapshot.data!.length;
                      double phAvg = snapshot.data!
                              .map((data) => data.phAverage)
                              .reduce((a, b) => a + b) /
                          snapshot.data!.length;

                      return Column(
                        children: [
                          _buildValueContainer("pH", phAvg),
                          SizedBox(height: 10),
                          _buildValueContainer("DO", doAvg),
                        ],
                      );
                    } else {
                      return Center(child: Text('Tidak ada data tersedia'));
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Rata-rata Harian'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('DO')],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'pH',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   child: _dailyData != null
                //       ? BarChartSample2(dailyData: _dailyData!)
                //       : Center(
                //       child: Text('Pilih minggu untuk melihat detail harian')),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text('Hari perminggu'),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.amber),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 1; i <= 4; i++)
                //         Container(
                //           padding: EdgeInsets.all(10),
                //           child: ElevatedButton(
                //             onPressed: () {
                //               _fetchDailyData(i);
                //               setState(() {
                //                 _activeButtonIndex = i; // Set tombol yang aktif
                //               });
                //             },
                //             child: Text(
                //               'Minggu $i',
                //               style: TextStyle(
                //                 color: _activeButtonIndex == i
                //                     ? Colors.teal
                //                     : Colors.white,
                //               ),
                //             ),
                //             style: ButtonStyle(
                //               shape:
                //               MaterialStateProperty.all<RoundedRectangleBorder>(
                //                 RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(20.0),
                //                 ),
                //               ),
                //               padding: MaterialStateProperty.all(
                //                   EdgeInsets.only(bottom: 5, left: 8, right: 8)),
                //               backgroundColor: MaterialStateProperty.all<Color>(
                //                 _activeButtonIndex == i
                //                     ? Colors.white
                //                     : Colors.teal,
                //               ),
                //             ),
                //           ),
                //         ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValueContainer(String label, double value) {
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
          SizedBox(height: 10),
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

class BarChartSample2 extends StatelessWidget {
  final List<DailyData> dailyData;

  BarChartSample2({required this.dailyData});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 38),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 14,
                  barTouchData: BarTouchData(
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
                        interval: 2,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: _generateDailyBarGroups(),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateDailyBarGroups() {
    return List.generate(dailyData.length, (i) {
      final daily = dailyData[i];
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

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['1', '2', '3', '4'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Widget _KarambaValues(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 19.h, right: 23.h),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 18.v,
          );
        },
        itemCount: 1,
        itemBuilder: (context, index) {},
      ),
    );
  }
}
