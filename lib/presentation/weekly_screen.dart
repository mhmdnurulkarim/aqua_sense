import 'package:flutter/material.dart';

import '../core/data_service.dart';
import '../widgets/chart.dart';
import '../widgets/widget_utils.dart';

class WeeklyScreen extends StatefulWidget {
  @override
  _WeeklyScreenState createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  final DataService _dataService = DataService();

  List<DataPoint> _todayData = [];
  List<String> _bottomTitles = [];
  bool _isLoading = false;

  bool _isLoadingDailyButtons = false;
  List<DateTime> _dailyDates = [];

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchTodayData(DateTime currentDate) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _dataService.getTodayData(currentDate);
      setState(() {
        _todayData = data;
        _bottomTitles =
            _todayData.map((dataPoint) => dataPoint.titleToday).toList();
      });

      if (_todayData.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tidak ada data untuk hari ini'),
          ),
        );
      }
    } catch (e) {
      // Handle error, e.g., show a SnackBar atau log the error
      print('Error fetching today data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat mengambil data: $e'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showDailyButtons(DateTime startDate) async {
    setState(() {
      _isLoadingDailyButtons = true;
    });

    List<DateTime> dates = [];
    for (int i = 0; i < 7; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }

    setState(() {
      _dailyDates = dates;
      _isLoadingDailyButtons = false;
    });
  }

  void _showDataBottomSheet(DateTime date) async {
    setState(() {
      _selectedDate = date;
    });
    await _fetchTodayData(date);
    if (_todayData.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return _buildBottomSheetContent();
        },
      );
    }
  }

  Widget _buildBottomSheetContent() {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(children: [
        _isLoading
            ? Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                children: [
                  SizedBox(height: 20),
                  SectionHeader(
                    text: 'Hari: ${_selectedDate != null ? formatDateInIndonesian(_selectedDate!): ''}',
                    padding: const EdgeInsets.all(8.0),
                  ),
                  ValueContainer(
                    label: 'pH',
                    value: _todayData[0].phAverage,
                  ),
                  SizedBox(height: 10),
                  ValueContainer(
                    label: 'DO',
                    value: _todayData[0].doAverage,
                  ),
                  SizedBox(height: 15),
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
                  if (_todayData != null)
                    CustomLineChart(
                      dataPoint: _todayData,
                      bottomTitles: _bottomTitles,
                    ),
                  Text('Jam'),
                  SizedBox(height: 15),
                ],
              )
      ]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            _buildWeeklyButtons(),
            _isLoadingDailyButtons
                ? Center(child: CircularProgressIndicator())
                : _buildDailyButtons(),
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
                    children: List.generate(4, (i) {
                      final startDate =
                          DateTime.now().subtract(Duration(days: (3 - i) * 7));
                      return Container(
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
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueGrey,
                            ),
                          ),
                          onPressed: () => _showDailyButtons(startDate),
                        ),
                      );
                    }),
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
              child: Text('Mohon tunggu, sedang mengambil data'),
            ),
          );
        }
      },
    );
  }

  Widget _buildDailyButtons() {
    return _dailyDates.isEmpty
        ? Container()
        : Expanded(
            child: ListView.builder(
              itemCount: _dailyDates.length,
              itemBuilder: (context, index) {
                final date = _dailyDates[index];
                final formattedDate = formatDateInIndonesian(date);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 5.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blueGrey,
                      ),
                    ),
                    child: Text(
                      formattedDate,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _showDataBottomSheet(date);
                    },
                  ),
                );
              },
            ),
          );
  }
}