import 'package:flutter/material.dart';

import '../core/utils/app_export.dart';
import '../widgets/chart.dart';
import '../widgets/widget_utils.dart';

class TodayScreen extends StatefulWidget {
  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final DataService _dataService = DataService();

  List<DataPoint> _todayData = [];
  List<String> _bottomTitles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTodayData();
  }

  Future<void> _fetchTodayData() async {
    setState(() {
      _isLoading = true;
    });

    final data = await _dataService.getTodayData();
    setState(() {
      _todayData = data;
      _bottomTitles = _todayData.map((dataPoint) => dataPoint.titleToday).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DataPoint>>(
        future: _dataService.getTodayData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            double doAvg = snapshot.data!
                    .map((data) => data.doAverage)
                    .reduce((a, b) => a + b) /
                snapshot.data!.length;
            double phAvg = snapshot.data!
                    .map((data) => data.phAverage)
                    .reduce((a, b) => a + b) /
                snapshot.data!.length;

            return SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        _isLoading
                            ? Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Column(
                                children: [
                                  SizedBox(height: 14.v),
                                  ValueContainer(
                                    label: 'pH',
                                    value: phAvg,
                                  ),
                                  SizedBox(height: 10),
                                  ValueContainer(
                                    label: 'DO',
                                    value: doAvg,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: padding10,
                                    child: Row(
                                      children: [
                                        LegendItem(
                                            label: 'DO', color: Colors.amber),
                                        SizedBox(width: 10),
                                        LegendItem(
                                            label: 'pH',
                                            color: Colors.indigo,
                                            textStyle: textStyleBoldWhite),
                                      ],
                                    ),
                                  ),
                                  CustomBarChart(
                                    dataPoint: _todayData,
                                    bottomTitles: _bottomTitles,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Text('Jam'),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text('Tidak ada data tersedia'),
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text('Mohon tunggu, sedang mengkalkulasi data'),
              ),
            );
          }
        });
  }
}
