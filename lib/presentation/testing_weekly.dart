// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../widgets/chart.dart';
// import '../widgets/widget_utils.dart';
//
// class DataService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<List<WeeklyData>> getWeeklyData() async {
//     List<WeeklyData> weeklyData = [];
//     DateTime now = DateTime.now();
//     int currentMonth = now.month;
//     DateTime firstDayOfMonth = DateTime(now.year, currentMonth, 1);
//
//     for (int week = 0; week < 4; week++) {
//       DateTime startOfWeek = firstDayOfMonth.add(Duration(days: week * 7));
//       DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
//
//       List<double> dailyDoAverages = [];
//       List<double> dailyPhAverages = [];
//
//       for (int day = 0; day < 7; day++) {
//         DateTime currentDate = startOfWeek.add(Duration(days: day));
//         var currentDateFormatted =
//             "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//         String dayOfWeek = getDayOfWeek(currentDate.weekday);
//
//         var querySnapshot = await _firestore
//             .collection('history')
//             .doc(currentDateFormatted)
//             .collection(dayOfWeek)
//             .get();
//
//         double dailyDoSum = 0;
//         double dailyPhSum = 0;
//         int dataCount = querySnapshot.docs.length;
//
//         if (dataCount > 0) {
//           querySnapshot.docs.forEach((doc) {
//             dailyDoSum += doc['DO'];
//             dailyPhSum += doc['pH'];
//           });
//
//           dailyDoAverages.add(dailyDoSum / dataCount);
//           dailyPhAverages.add(dailyPhSum / dataCount);
//         }
//       }
//
//       if (dailyDoAverages.isNotEmpty && dailyPhAverages.isNotEmpty) {
//         double weeklyDoAverage =
//             dailyDoAverages.reduce((a, b) => a + b) / dailyDoAverages.length;
//         double weeklyPhAverage =
//             dailyPhAverages.reduce((a, b) => a + b) / dailyPhAverages.length;
//         weeklyData.add(WeeklyData(weeklyDoAverage, weeklyPhAverage));
//       }
//     }
//     return weeklyData;
//   }
//
//   Future<List<DailyData>> getDailyData(int weekNumber) async {
//     List<DailyData> dailyData = [];
//     DateTime now = DateTime.now();
//     int currentMonth = now.month;
//     DateTime firstDayOfMonth = DateTime(now.year, currentMonth, 1);
//     DateTime startOfWeek = firstDayOfMonth.add(Duration(days: (weekNumber - 1) * 7));
//
//     for (int day = 0; day < 7; day++) {
//       DateTime currentDate = startOfWeek.add(Duration(days: day));
//       var currentDateFormatted =
//           "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//       String dayOfWeek = getDayOfWeek(currentDate.weekday);
//
//       var querySnapshot = await _firestore
//           .collection('history')
//           .doc(currentDateFormatted)
//           .collection(dayOfWeek)
//           .get();
//
//       double dailyDoSum = 0;
//       double dailyPhSum = 0;
//       int dataCount = querySnapshot.docs.length;
//
//       if (dataCount > 0) {
//         querySnapshot.docs.forEach((doc) {
//           dailyDoSum += doc['DO'];
//           dailyPhSum += doc['pH'];
//         });
//
//         dailyData
//             .add(DailyData(dailyDoSum / dataCount, dailyPhSum / dataCount));
//       } else {
//         dailyData.add(DailyData(0, 0));
//       }
//     }
//
//     return dailyData;
//   }
// }
//
// class TestingWeekly extends StatefulWidget {
//   @override
//   _TestingWeeklyState createState() => _TestingWeeklyState();
// }
//
// class _TestingWeeklyState extends State<TestingWeekly> {
//   final DataService _dataService = DataService();
//   final List<DateTime?> selectedDatesFromCalendar = [];
//   List<WeeklyData> _weeklyData = [];
//   List<DailyData>? _dailyData;
//   int _selectedWeek = -1;
//   int _activeButtonIndex = -1;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchWeeklyData();
//   }
//
//   Future<void> _fetchWeeklyData() async {
//     final data = await _dataService.getWeeklyData();
//     setState(() {
//       _weeklyData = data;
//     });
//   }
//
//   Future<void> _fetchDailyData(int weekNumber) async {
//     final data = await _dataService.getDailyData(weekNumber);
//     setState(() {
//       _dailyData = data;
//       _selectedWeek = weekNumber;
//     });
//   }
//
//   void _showDataForWeek(BuildContext context, int weekNumber) {
//     if (weekNumber <= _weeklyData.length) {
//       final data = _weeklyData[weekNumber - 1];
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           backgroundColor: Colors.indigo,
//           title: Text(
//             'Data for Week $weekNumber',
//           ),
//           content: Text(
//             'DO Average: ${data.doAverageFormatted}\nPH Average: ${data.phAverageFormatted}',
//             style: TextStyle(color: Colors.white),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 'OK',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('No data available for Week $weekNumber')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Column(
//           children: [
//             Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text('Rata-rata Mingguan'),
//                 )),
//             FutureBuilder<List<WeeklyData>>(
//               future: _dataService.getWeeklyData(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('Tidak ada data tersedia'));
//                 }
//
//                 final weeklyData = snapshot.data!;
//
//                 return SizedBox(
//                   width: double.maxFinite,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             for (int i = 1; i <= 4; i++)
//                               Container(
//                                 padding: EdgeInsets.all(10),
//                                 child: ElevatedButton(
//                                   onPressed: () => _showDataForWeek(context, i),
//                                   child: Text(
//                                     'Minggu $i',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   style: ButtonStyle(
//                                     shape: MaterialStateProperty.all<
//                                         RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                         borderRadius:
//                                         BorderRadius.circular(8.0),
//                                       ),
//                                     ),
//                                     padding: MaterialStateProperty.all(
//                                         EdgeInsets.only(
//                                             bottom: 5, left: 8, right: 8)),
//                                     backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Colors.blueGrey),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text('Rata-rata Harian'),
//                 )),
//             SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 20.0),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(3),
//                     decoration: BoxDecoration(
//                       color: Colors.amber,
//                       borderRadius: BorderRadius.circular(3),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [Text('DO')],
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(3),
//                     decoration: BoxDecoration(
//                       color: Colors.indigo,
//                       borderRadius: BorderRadius.circular(3),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'pH',
//                           style: TextStyle(color: Colors.white),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: _dailyData != null
//                   ? BarChartSample2(dailyData: _dailyData!)
//                   : Center(
//                   child: Text('Pilih minggu untuk melihat detail harian')),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20.0),
//               child: Text('Hari perminggu'),
//             ),
//             Container(
//               decoration: BoxDecoration(color: Colors.amber),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   for (int i = 1; i <= 4; i++)
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           _fetchDailyData(i);
//                           setState(() {
//                             _activeButtonIndex = i; // Set tombol yang aktif
//                           });
//                         },
//                         child: Text(
//                           'Minggu $i',
//                           style: TextStyle(
//                             color: _activeButtonIndex == i
//                                 ? Colors.teal
//                                 : Colors.white,
//                           ),
//                         ),
//                         style: ButtonStyle(
//                           shape:
//                           MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20.0),
//                             ),
//                           ),
//                           padding: MaterialStateProperty.all(
//                               EdgeInsets.only(bottom: 5, left: 8, right: 8)),
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                             _activeButtonIndex == i
//                                 ? Colors.white
//                                 : Colors.teal,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
