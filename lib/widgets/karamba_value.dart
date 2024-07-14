import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_export.dart'; // ignore: must_be_immutable

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class ViewhierarchylistItemWidget extends StatelessWidget {
  const ViewhierarchylistItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
      // FirebaseFirestore.instance
      //     .collection('karamba')
      //     .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
      //     .snapshots(),

      FirebaseFirestore.instance
          .collection('karamba')
          .doc('2024-07-07')
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
          final pHValue = historyData[
              'pH']; // Assuming there's a field named 'pH' in your document
          final doValue = historyData['DO'];

          if (doValue > 5 && pHValue <= 6) {
            // Send push notification for pH warning
            _sendNotification('Peringatan',
                'pH tidak sesuai standar, air dalam keadaan asam');
          } else if (doValue <= 5 && pHValue > 6) {
            // Send push notification for DO warning
            _sendNotification('Peringatan',
                'Konsentrasi oksigen tidak sesuai standar, kadar oksigen mengalami penurunan');
          } else if (pHValue <= 6 && doValue <= 5) {
            // Send emergency push notification
            _sendNotification(
                'Evakuasi Ikan', 'Segera evakuasi ikan, terjadi tubo balerang');
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
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold), // Adjust the style as needed
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      pHValue.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
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
                        "DO",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold), // Adjust the style as needed
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      doValue.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          // If the document doesn't exist
          return Text('Tidak ada data untuk hari ini.');
        }
      },
    );
  }

  // Helper function to get current date in Firestore compatible format (YYYY-MM-DD)
  String _getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
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
