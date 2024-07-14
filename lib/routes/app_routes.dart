import 'package:flutter/material.dart';

import '../presentation/app_navigation_screen.dart';
import '../presentation/splash_screen.dart';
import '../presentation/this_month_screen.dart';
import '../presentation/today_screen.dart';
import '../presentation/weekly_screen.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String tampilanAwalScreen = '/splash_screen';

  static const String tampilanTodayScreen = '/today_screen';

  static const String tampilanWeeklyScreen = '/weekly_screen';

  static const String tampilanThisMonthScreen = '/this_month_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    tampilanAwalScreen: (context) => SplashScreen(),
    tampilanTodayScreen: (context) => TodayScreen(),
    tampilanWeeklyScreen: (context) => WeeklyScreen(),
    tampilanThisMonthScreen: (context) => ThisMonthScreen(),
    appNavigationScreen: (context) => AppNavigationScreen(),
    initialRoute: (context) => AppNavigationScreen()
  };
}
