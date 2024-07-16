import 'package:flutter/material.dart';

import '../presentation/this_month_screen.dart';
import '../presentation/today_screen.dart';
import '../presentation/weekly_screen.dart';

class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({Key? key}) : super(key: key);

  @override
  State<AppNavigationScreen> createState() => _AppNavigationScreenState();
}

class _AppNavigationScreenState extends State<AppNavigationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Align(
            alignment: Alignment.center,
            child: Text(
              "Karamba Warning",
              style: TextStyle(color: Colors.white, fontSize: 24),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          bottom: TabBar(
            labelStyle:
                TextStyle(color: Colors.white, fontFamily: 'ItimRegular'),
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                text: 'Harian',
              ),
              Tab(
                text: 'Minguan',
              ),
              Tab(
                text: 'Bulan ini',
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            TodayScreen(),
            WeeklyScreen(),
            ThisMonthScreen(),
          ],
        ),
      ),
    );
  }
}
