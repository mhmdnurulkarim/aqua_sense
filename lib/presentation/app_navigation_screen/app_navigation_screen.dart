import 'package:aini_s_application1/core/app_export.dart';
import 'package:aini_s_application1/presentation/tampilan_this_month_screen/tampilan_this_month_screen.dart';
import 'package:aini_s_application1/presentation/tampilan_today_screen/tampilan_today_screen.dart';
import 'package:aini_s_application1/presentation/tampilan_weekly_screen/tampilan_weekly_screen.dart';
import 'package:aini_s_application1/theme/app_decoration.dart';
import 'package:flutter/material.dart';

class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({Key? key})
      : super(
          key: key,
        );

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
              // Assuming you have 'theme' defined somewhere
              // Change it to your actual theme or define it
              // in your code.
              // style: Theme.of(context).textTheme.headline6,
              // Using headline6 as an example. Adjust as needed.
            ),
          ),
          bottom: TabBar(
            labelStyle: TextStyle(color: Colors.white, fontFamily: 'ItimRegular'),
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                text: 'Today',
              ),
              Tab(
                text: 'Weekly',
              ),
              Tab(
               text: 'This Month',
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            TampilanTodayScreen(),
            TampilanWeeklyScreen(),
            TampilanThisMonthScreen(),
          ],
        ),
      ),
    );
  }
}




Widget _buildKarambawaColumn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 39.h,
        vertical: 6.v,
      ),
      decoration: AppDecoration.fillBlueGray,
      child: Column(
        children: [
          SizedBox(height: 29.v),
          SizedBox(
            width: 78,
            child: Text(
              "Karamba Warning",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 30.v),
          Padding(
            padding: EdgeInsets.only(right: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: AppDecoration.outlineBlack,
                  child: Text(
                    "Today",
                    style: CustomTextStyles.bodySmallInder,
                  ),
                ),
                Spacer(
                  flex: 57,
                ),
                Text(
                  "Weekly",
                  style: theme.textTheme.bodySmall,
                ),
                Spacer(
                  flex: 42,
                ),
                Text(
                  "this month",
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
