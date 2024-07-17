import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../widgets/widget_utils.dart';

class WeeklyScreen extends StatefulWidget {
  @override
  _WeeklyScreenState createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  final DataService _dataService = DataService();

  List<WeeklyData> _weeklyData = [];
  List<DailyData>? _dailyData;
  WeeklyData? _selectedWeeklyData;
  int? _selectedWeekNumber;

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
    final data = await _dataService.getDailyData(weekNumber);
    setState(() {
      _dailyData = data;
    });
  }

  void _showData(int weekNumber) async {
    if (weekNumber < _weeklyData.length) {
      await _fetchDailyData(weekNumber + 1);
      setState(() {
        _selectedWeeklyData = _weeklyData[weekNumber];
        _selectedWeekNumber = weekNumber;
      });
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
    return FutureBuilder<List<WeeklyData>>(
      future: _dataService.getWeeklyData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(snapshot.data!.length, (i) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text(
                        'Minggu ${i + 1}',
                        style: TextStyle(color: Colors.white),
                      ),
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
                      onPressed: () => _showData(i),
                    ),
                  );
                }),
              ),
            ),
          );
        } else {
          return Center(child: Text('Tidak ada data tersedia'));
        }
      },
    );
  }

  Widget _buildWeeklyDetails() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Rata-rata Mingguan'),
              _buildDataContainer(
                label: 'pH',
                value: _selectedWeeklyData!.phAverageFormatted.toString(),
                color: Colors.blueGrey,
              ),
              SizedBox(height: 10),
              _buildDataContainer(
                label: 'DO',
                value: _selectedWeeklyData!.doAverageFormatted.toString(),
                color: Colors.blueGrey,
              ),
              SizedBox(height: 15),
              _buildSectionTitle('Rata-rata Harian'),
              SizedBox(height: 20),
              _buildLegend(),
              if (_dailyData != null) BarChartSample2(dailyData: _dailyData!),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text('Hari perminggu'),
              ),
              Container(decoration: BoxDecoration(color: Colors.amber)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(title),
      ),
    );
  }

  Widget _buildDataContainer({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
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
            value,
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

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          _buildLegendItem('DO', Colors.amber),
          SizedBox(width: 10),
          _buildLegendItem('pH', Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
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
            style: TextStyle(color: Colors.white),
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
              child: _buildBarChart(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  BarChart _buildBarChart() {
    return BarChart(
      BarChartData(
        maxY: 20,
        barTouchData: _buildBarTouchData(),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(show: false),
        barGroups: _generateDailyBarGroups(),
        gridData: const FlGridData(show: false),
      ),
    );
  }

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
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
      touchCallback: (FlTouchEvent event, BarTouchResponse? response) {},
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: _bottomTitles,
          reservedSize: 42,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          interval: 1,
          getTitlesWidget: _leftTitles,
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

  Widget _bottomTitles(double value, TitleMeta meta) {
    const titles = <String>['1', '2', '3', '4', '5', '6', '7'];
    final title = titles[value.toInt()];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _leftTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: Text(
        value.toString(),
        style: style,
      ),
    );
  }
}
