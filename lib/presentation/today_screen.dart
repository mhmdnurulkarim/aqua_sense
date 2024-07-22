import 'dart:async';

import 'package:flutter/material.dart';

import '../core/data_service.dart';
import '../core/notification_service.dart';
import '../widgets/chart.dart';
import '../widgets/widget_utils.dart';

class TodayScreen extends StatefulWidget {
  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final DataService _dataService = DataService();
  final NotificationService _notificationService = NotificationService();

  // DateTime currentDate = DateTime.now();
  DateTime currentDate = DateTime(2024,7,19);
  List<DataPoint> _todayData = [];
  List<String> _bottomTitles = [];
  bool _isLoading = false;

  double doAvg = 0;
  double phAvg = 0;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  @override
  void initState() {
    super.initState();
    _fetchTodayData(currentDate);
    _notificationService.initialize();

    _subscription = _dataService.listenToTodayData().listen((data) {
      setState(() {
        phAvg = data['pH'] ?? 0;
        doAvg = data['DO'] ?? 0;
      });

      // Periksa dan tampilkan notifikasi jika nilai mendekati ThresholdValue
      _notificationService.checkAndNotify(phAvg, doAvg);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchTodayData(DateTime currentDate) async {
    setState(() {
      _isLoading = true;
    });

    final data = await _dataService.getTodayData(currentDate);
    setState(() {
      _todayData = data;
      _bottomTitles = _todayData.map((dataPoint) => dataPoint.titleToday).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DataPoint>>(
        future: _dataService.getTodayData(currentDate),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                                  SizedBox(height: 14),
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
                                  CustomLineChart(
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
