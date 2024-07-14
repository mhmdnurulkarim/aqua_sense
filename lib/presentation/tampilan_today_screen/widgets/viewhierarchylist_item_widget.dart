import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/app_export.dart'; // ignore: must_be_immutable

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:awesome_notifications/awesome_notifications.dart';



class ViewhierarchylistItemWidget extends StatelessWidget {
  const ViewhierarchylistItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
  stream: 
        // FirebaseFirestore.instance
        // .collection('karamba')
        // .doc('2024-05-28')
        // .snapshots(),
  
        FirebaseFirestore.instance
        .collection('karamba')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .snapshots(),
  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator(); // Show loading indicator while waiting for data
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    if (snapshot.hasData && snapshot.data!.exists) {
      // If the document exists
      final historyData = snapshot.data!.data() as Map<String, dynamic>;
      final pHValue = historyData['pH']; // Assuming there's a field named 'pH' in your document
      final doValue = historyData['DO'];

      if (doValue > 5 && pHValue <= 6) {
            // Send push notification for pH warning
            _sendNotification('Peringatan', 'pH tidak sesuai standar, air dalam keadaan asam');
          } else if (doValue <= 5 && pHValue > 6) {
            // Send push notification for DO warning
            _sendNotification('Peringatan', 'Konsentrasi oksigen tidak sesuai standar, kadar oksigen mengalami penurunan');
          } else if (pHValue <= 6 && doValue <= 5) {
            // Send emergency push notification
            _sendNotification('Evakuasi Ikan', 'Segera evakuasi ikan, terjadi tubo balerang');
          }
      return Column(
        children: [
          Container(
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
              "pH",
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), // Adjust the style as needed
            ),
          ),
          SizedBox(height: 10),
          Text(
            pHValue.toString(),
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
              ],
            ),
          ),
            SizedBox(height: 10),
          Container(
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
              "Oksigen",
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), // Adjust the style as needed
            ),
          ),
          SizedBox(height: 10),
          Text(
            doValue.toString(),
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
              ],
            ),
          ),
        ],
      );

    } else {
      // If the document doesn't exist
      return Text('No data available for today.');
    }
  },
);
  }

  // Helper function to get current date in Firestore compatible format (YYYY-MM-DD)
  String _getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return formattedDate;
  }
  Future<void> _sendNotification(String title, String message) async {
     int notificationId = DateTime.now().millisecondsSinceEpoch & 0xffffffff;
     AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
         actionType: ActionType.Default,
        title: title,
        body: message,
      ),
    );
  }
}



// class ViewOksigen extends StatelessWidget {
//   const ViewOksigen({Key? key})
//       : super(
//           key: key,
//         );

//   @override
//   Widget build(BuildContext context) { 
//     return StreamBuilder(
//   stream: 
//         // FirebaseFirestore.instance
//         // .collection('karamba')
//         // .doc('2024-05-28')
//         // .snapshots(),
  
//         FirebaseFirestore.instance
//         .collection('karamba')
//         .doc(_getCurrentDate()) // Use the specific document ID (today's date) here
//         .snapshots(),
//   builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return CircularProgressIndicator(); // Show loading indicator while waiting for data
//     }
//     if (snapshot.hasError) {
//       return Text('Error: ${snapshot.error}');
//     }
//     if (snapshot.hasData && snapshot.data!.exists) {
//       // If the document exists
//       final historyData = snapshot.data!.data() as Map<String, dynamic>;
//       final pHValue = historyData['DO']; // Assuming there's a field named 'pH' in your document
//       return Container(
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//           color: Colors.blueGrey,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(left: 11),
//               child: Text(
//                 "Oksigen",
//                 style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), // Adjust the style as needed
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               pHValue.toString(),
//               style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // If the document doesn't exist
//       return Text('No data available for today.');
//     }
//   },
// );
//   }
//     String _getCurrentDate() {
//     DateTime now = DateTime.now();
//     String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
//     return formattedDate;
//   }
// }





class BarChartSample2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 7;
  late List<BarChartGroupData> showingBarGroups;
  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    // Initialize showingBarGroups with an empty list
    showingBarGroups = [];
    // Fetch data from Firebase and populate showingBarGroups
    fetchFirebaseData();
  }

  String getDayOfWeek(int weekday) {
  switch (weekday) {
    case 1:
      return 'senin';
    case 2:
      return 'selasa';
    case 3:
      return 'rabu';
    case 4:
      return 'kamis';
    case 5:
      return 'jumat';
    case 6:
      return 'sabtu';
    case 7:
      return 'minggu';
    default:
      return '';
  }
}



void fetchFirebaseData() async {
  var currentDate = DateTime.now();
  var currentDateFormatted =
      "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";


      print(currentDateFormatted);

      String dayOfWeek = getDayOfWeek(currentDate.weekday);
      print(dayOfWeek);

      if (dayOfWeek.isEmpty) {
        print('Error: Invalid day of week');
        return;
      }

  // Fetch data from Firebase
  var querySnapshot = await FirebaseFirestore.instance
      .collection('history')
      .doc(currentDateFormatted)
      .collection(dayOfWeek)
      .get();

    // var querySnapshot = await FirebaseFirestore.instance
    //   .collection('history')
    //   .doc('2024-05-28')
    //   .collection('selasa')
    //   .get();

  // Process fetched data
  var barGroups = <BarChartGroupData>[];
  querySnapshot.docs.forEach((doc) {
    var doValue = doc['DO'] != null ? doc['DO'].toDouble() : 0;
    var phValue = doc['pH'] != null ? doc['pH'].toDouble() : 0;
    var barGroup = makeGroupData(barGroups.length, doValue, phValue);
    barGroups.add(barGroup);
  });

  setState(() {
    showingBarGroups = barGroups;
  });
}



  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 20, // Adjust max value as needed
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: ((group) {
                        return Colors.grey;
                      }),
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      // Your touch callback logic here
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

Widget leftTitles(double value, TitleMeta meta) {
  if (value % 10 == 0 && value <= 30) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(
        value.toInt().toString(),
        style: const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  } else {
    return Container();
  }
}


 Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['7.00', '8.00', '9.00', '10.00', '11.00', '12.00', '13.00, 14:00, 15.00, 16.00,'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }


  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.amber,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.indigo,
          width: width,
        ),
      ],
    );
  }
}
