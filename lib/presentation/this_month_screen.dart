import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
    const padding8 = EdgeInsets.all(8);
    const padding20 = EdgeInsets.only(left: 20);
    const textStyleBoldWhite = TextStyle(color: Colors.white);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              children: [
                _buildSectionHeader('Rata-rata Bulan ini', padding8),
                _buildAverageDataSection(),
                SizedBox(height: 20),
                _buildSectionHeader('Rata-rata Harian', padding8),
                SizedBox(height: 20),
                _buildLegendRow(padding20, textStyleBoldWhite),
                SizedBox(height: 10),
                _buildBarChart(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text('Hari perminggu'),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.amber),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text, EdgeInsets padding) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: padding,
        child: Text(text),
      ),
    );
  }

  Widget _buildAverageDataSection() {
    return FutureBuilder<List<WeeklyData>>(
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

  Widget _buildLegendRow(EdgeInsets padding, TextStyle textStyle) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          _buildLegendItem('DO', Colors.amber),
          SizedBox(width: 10),
          _buildLegendItem('pH', Colors.indigo, textStyle),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, [TextStyle? textStyle]) {
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

  Widget _buildBarChart() {
    return BarChartSample2(weeklyData: _weeklyData);
  }
}

class BarChartSample2 extends StatelessWidget {
  final List<WeeklyData> weeklyData;

  BarChartSample2({required this.weeklyData});

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
    return List.generate(weeklyData.length, (i) {
      final daily = weeklyData[i];
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
    const titles = <String>['1', '2', '3', '4'];
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