import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final double pHThreshold = 6.0; // Ambang batas untuk pH
  final double doThreshold = 4.0; // Ambang batas untuk DO

  Future<void> initialize() async {
    // Konfigurasi notifikasi lokal
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: (String? payload) async {
      //   // Handle notification tap
      // },
    );

    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Handle the message
      FirebaseMessaging.onMessage.listen(_handleMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    }
  }

  void _handleMessage(RemoteMessage message) {
    if (message.notification != null) {
      _showNotification(
        title: message.notification!.title ?? 'No Title',
        body: message.notification!.body ?? 'No Body',
      );
    }
  }

  Future<void> _showNotification({
    required String title,
    required String body,
    String? channelId = 'your_channel_id',
    String? channelName = 'your_channel_name',
    String? channelDescription = 'your_channel_description',
    String? payload = 'item x',
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId ?? 'your_channel_id',
      channelName ?? 'your_channel_name',
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  void checkAndNotify(double? pHValue, double? doValue) {
    if (pHValue != null && pHValue == 0 && doValue != null && doValue == 0) {
    }
    else if (pHValue != null && pHValue < pHThreshold && doValue != null && doValue < doThreshold) {
      _showNotification(
        title: 'Karamba dalam bahaya!',
        body: 'Segera evakuasi ikan!, terjadi tubo balerang.',
      );
    }
    else if (pHValue != null && pHValue < pHThreshold) {
      _showNotification(
        title: 'Peringatan: Keasaman air $pHValue',
        body: 'Segera evakuasi ikan!, air danau dalam keadaan asam.',
      );
    }
    else if (doValue != null && doValue < doThreshold) {
      _showNotification(
        title: 'Peringatan: Kadar Oksigen $doValue',
        body: 'Segera evakuasi ikan!, kadar oksigen mengalami penurunan.',
      );
    }
  }
}
