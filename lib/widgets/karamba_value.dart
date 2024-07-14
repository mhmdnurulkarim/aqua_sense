import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class KarambaValues extends StatelessWidget {
  const KarambaValues({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          // FirebaseFirestore.instance
          //     .collection('karamba')
          //     .doc(currentDateFormatted)
          //     .snapshots(),

          FirebaseFirestore.instance
              .collection('karamba')
              .doc('2024-05-08')
              .snapshots(),

      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.exists) {

          // If the document exists
          final historyData = snapshot.data!.data() as Map<String, dynamic>;
          final pHValue = historyData['pH'];
          final doValue = historyData['DO'];

          // if (doValue > 5 && pHValue <= 6) {
          //   // Send push notification for pH warning
          //   _sendNotification('Peringatan',
          //       'pH tidak sesuai standar, air dalam keadaan asam');
          // } else if (doValue <= 5 && pHValue > 6) {
          //   // Send push notification for DO warning
          //   _sendNotification('Peringatan',
          //       'Konsentrasi oksigen tidak sesuai standar, kadar oksigen mengalami penurunan');
          // } else if (pHValue <= 6 && doValue <= 5) {
          //   // Send emergency push notification
          //   _sendNotification(
          //       'Evakuasi Ikan', 'Segera evakuasi ikan, terjadi tubo balerang');
          // }
          return Column(
            children: [

              //Container Value pH
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

              //Container Value Oksigen
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

  // Future<void> _sendNotification(String title, String message) async {
  //   int notificationId = DateTime.now().millisecondsSinceEpoch & 0xffffffff;
  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: 1,
  //       channelKey: 'basic_channel',
  //       actionType: ActionType.Default,
  //       title: title,
  //       body: message,
  //     ),
  //   );
  // }
}
