import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Android設定
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS設定
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    // 初期化設定
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    print('通知サービスの初期化が完了しました');
  }

  static void _onNotificationTap(NotificationResponse response) {
    // 通知がタップされた時の処理
    print('通知がタップされました: ${response.payload}');
  }

  static Future<void> showAlarmNotification() async {
    // Android通知設定
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'alarm_channel',
          'アラーム通知',
          channelDescription: 'アラーム時刻の通知',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );

    // iOS通知設定
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    // 通知詳細
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    // 通知を表示
    await _notifications.show(
      0, // 通知ID
      '⏰ アラーム時刻です！',
      '設定した時刻になりました。アラームを止めるボタンを押してください。',
      details,
      payload: 'alarm_notification',
    );

    print('アラーム通知を表示しました');
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    print('全ての通知をキャンセルしました');
  }
}
