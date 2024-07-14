import 'package:flutter/material.dart';

import '../presentation/app_navigation_screen.dart';
import '../presentation/splash_screen.dart';
import '../presentation/testing_weekly.dart';
import '../presentation/this_month_screen.dart';
import '../presentation/today_screen.dart';
import '../presentation/weekly_screen.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String _SplashScreen = '/splash_screen';

  static const String _TodayScreen = '/today_screen';

  static const String _WeeklyScreen = '/testing_weekly';

  static const String _ThisMonthScreen = '/this_month_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    _SplashScreen: (context) => SplashScreen(),
    _TodayScreen: (context) => TodayScreen(),
    _WeeklyScreen: (context) => WeeklyScreen(),
    _ThisMonthScreen: (context) => ThisMonthScreen(),
    appNavigationScreen: (context) => AppNavigationScreen(),
    initialRoute: (context) => AppNavigationScreen()
  };
}
