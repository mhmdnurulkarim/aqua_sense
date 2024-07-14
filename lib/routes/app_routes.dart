import 'package:flutter/material.dart';
import '../core/app_export.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/tampilan_awal_screen/tampilan_awal_screen.dart';
import '../presentation/tampilan_this_month_screen/tampilan_this_month_screen.dart';
import '../presentation/tampilan_today_screen/tampilan_today_screen.dart';
import '../presentation/tampilan_weekly_screen/tampilan_weekly_screen.dart'; // ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String tampilanAwalScreen = '/tampilan_awal_screen';

  static const String tampilanTodayScreen = '/tampilan_today_screen';

  static const String tampilanWeeklyScreen = '/tampilan_weekly_screen';

  static const String tampilanThisMonthScreen = '/tampilan_this_month_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    tampilanAwalScreen: (context) => TampilanAwalScreen(),
    tampilanTodayScreen: (context) => TampilanTodayScreen(),
    // tampilanWeeklyScreen: (context) => TampilanWeeklyScreen(),
    tampilanThisMonthScreen: (context) => TampilanThisMonthScreen(),
    // appNavigationScreen: (context) => AppNavigationScreen(),
    initialRoute: (context) => AppNavigationScreen()
  };
}
