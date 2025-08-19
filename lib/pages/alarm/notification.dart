import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification {
  static const String channelId = 'default_channel_id';
  static const String channelName = 'Default Channel';
  static const String channelDescription =
      'This is the default notification channel.';
}

class SimpleNotificationService {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // 通知サービスの初期化
  static Future<void> initialize() async {
    // Android 初期設定
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 初期設定
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // 全体の初期設定
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          _onDidReceiveNotificationResponse, // 未実装
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse, // 未実装
    );

    if (Platform.isIOS) {
      await _requestIOSPermissions(); // 未実装
    } else if (Platform.isAndroid) {
      await _requestAndroidPermissions(); // 未実装
    } else {
      debugPrint('通知権限のリクエストはサポートされていません');
    }
  }

  // iOS 通知権限のリクエスト
  static Future<void> _requestIOSPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  // Android 通知権限のリクエスト
  static Future<void> _requestAndroidPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // 通知のタップ時の処理
  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    debugPrint('onDidReceiveNotificationResponse: $response');
  }

  // バックグラウンドで通知を受け取った時の処理
  static Future _onDidReceiveBackgroundNotificationResponse(
      NotificationResponse response) async {
    debugPrint('onDidReceiveBackgroundNotificationResponse: $response');
  }

    // 通知の送信
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    
    // Android 用のスタイル情報
    const androidNotificationDetails = AndroidNotificationDetails(
      Notification.channelId,
      Notification.channelName,
      channelDescription: Notification.channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );

    // iOS 用のスタイル情報
    const iosNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            SimpleNotificationService.showNotification(
              id: 0,
              title: 'Hello World !',
              body: 'Happy Coding! 🚀',
            );
          },
          child: const Text('テスト'),
        ),
      ),
    );
  }
}