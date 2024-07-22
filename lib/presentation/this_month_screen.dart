import 'package:flutter/material.dart';

import '../widgets/chart.dart';
import '../core/data_service.dart';
import '../widgets/widget_utils.dart';

class ThisMonthScreen extends StatefulWidget {
  @override
  _ThisMonthScreenState createState() => _ThisMonthScreenState();
}

class _ThisMonthScreenState extends State<ThisMonthScreen> {
  final DataService _dataService = DataService();

  List<DataPoint> _weeklyData = [];
  List<DataPoint>? _dailyData;
  List<String> _bottomTitles = [];
  DataPoint? _selectedWeeklyData;
  bool _isLoading = false;

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

  Future<void> _fetchDailyData(int weekNumber) async {
    setState(() {
      _isLoading = true;
    });

    final data = await _dataService.getDailyData(weekNumber);
    setState(() {
      _dailyData = data;
      _bottomTitles =
          List.generate(_dailyData!.length, (index) => (index + 1).toString());
      _isLoading = false;
    });
  }

  void _showData(int weekNumber) async {
    if (weekNumber < _weeklyData.length) {
      setState(() {
        _selectedWeeklyData = _weeklyData[weekNumber];
      });
      await _fetchDailyData(weekNumber + 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No data available for Week ${weekNumber + 1}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            _buildWeeklyButtons(),
            if (_selectedWeeklyData != null) _buildWeeklyDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyButtons() {
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
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Text('Tidak ada data tersedia'),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 4; i++)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                            child: Text(
                              'Minggu ${i + 1}',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blueGrey,
                              ),
                            ),
                            onPressed: () => _showData(i),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Text('Mohon tunggu, sedang mengambil data'),
            ),
          );
        }
      },
    );
  }

  Widget _buildWeeklyDetails() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              _isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Column(
                      children: [
                        SectionHeader(
                          text: 'Rata-rata Mingguan',
                          padding: padding8,
                        ),
                        ValueContainer(
                          label: 'pH',
                          value: _selectedWeeklyData!.phAverage,
                        ),
                        SizedBox(height: 10),
                        ValueContainer(
                          label: 'DO',
                          value: _selectedWeeklyData!.doAverage,
                        ),
                        SizedBox(height: 15),
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
                        if (_dailyData != null)
                          CustomLineChart(
                              dataPoint: _dailyData!,
                              bottomTitles: _bottomTitles),
                        Text('Hari perminggu'),
                        SizedBox(height: 15),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
