import 'package:flutter/material.dart';

import '../widgets/chart.dart';
import '../widgets/widget_utils.dart';

class ThisMonthScreen extends StatefulWidget {
  @override
  _ThisMonthScreenState createState() => _ThisMonthScreenState();
}

class _ThisMonthScreenState extends State<ThisMonthScreen> {
  final DataService _dataService = DataService();
  List<DataPoint> _weeklyData = [];
  List<String> _bottomTitles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeeklyData();
  }

  Future<void> _fetchWeeklyData() async {
    setState(() {
      _isLoading = true;
    });

    final data = await _dataService.getWeeklyData();
    setState(() {
      _weeklyData = data;
      _bottomTitles = List.generate(_weeklyData.length, (index) => (index + 1).toString());
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: _isLoading
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    children: [
                      SectionHeader(
                          text: 'Rata-rata Bulan ini', padding: padding8),
                      _buildAverageDataSection(),
                      SizedBox(height: 10),
                      SectionHeader(
                          text: 'Rata-rata Harian', padding: padding8),
                      Padding(
                        padding: padding10,
                        child: Row(
                          children: [
                            LegendItem(label: 'DO', color: Colors.amber),
                            SizedBox(width: 10),
                            LegendItem(
                                label: 'pH',
                                color: Colors.indigo,
                                textStyle: textStyleBoldWhite),
                          ],
                        ),
                      ),
                      CustomBarChart(
                          dataPoint: _weeklyData, bottomTitles: _bottomTitles),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text('Hari perminggu'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAverageDataSection() {
    return FutureBuilder<List<DataPoint>>(
      future: _dataService.getWeeklyData(),
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

          return Column(
            children: [
              ValueContainer(label: "pH", value: phAvg),
              SizedBox(height: 10),
              ValueContainer(label: "DO", value: doAvg),
            ],
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
      },
    );
  }
}
