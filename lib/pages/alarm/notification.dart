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

  // シンプルな通知送信（Android対応強化）
  static Future<void> showLocalNotification(
    String title,
    String message,
  ) async {
    // Android用：詳細設定で確実に表示
    const androidNotificationDetail = AndroidNotificationDetails(
      'channel_id', // channel Id
      'channel_name', // channel Name
      channelDescription: 'Main notification channel',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      showWhen: true,
      autoCancel: true,
      ongoing: false,
      silent: false,
      channelShowBadge: true,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    const iosNotificationDetail = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const notificationDetails = NotificationDetails(
      iOS: iosNotificationDetail,
      android: androidNotificationDetail,
    );

    try {
      // ユニークなIDを生成してAndroid通知の重複を防ぐ
      final int notificationId =
          DateTime.now().millisecondsSinceEpoch % 2147483647;
      await FlutterLocalNotificationsPlugin().show(
        notificationId,
        title,
        message,
        notificationDetails,
      );
      debugPrint('Android通知送信成功: $title (ID: $notificationId)');
    } catch (e) {
      debugPrint('Android通知送信エラー: $e');
    }
  }

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
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
    );

    // Android通知チャンネルを作成
    if (Platform.isAndroid) {
      await _createAndroidNotificationChannel();
      await _requestAndroidPermissions();
    } else if (Platform.isIOS) {
      await _requestIOSPermissions();
    } else {
      debugPrint('通知権限のリクエストはサポートされていません');
    }

    debugPrint('通知サービスの初期化が完了しました');
  }

  // Android通知チャンネルの作成（強化版）
  static Future<void> _createAndroidNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id',
      'channel_name',
      description: 'Main notification channel for Android push notifications',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
      enableLights: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    debugPrint('Android通知チャンネル作成完了: ${channel.id}');

    // 通知チャンネルが正しく作成されたか確認
    final List<AndroidNotificationChannel>? channels =
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.getNotificationChannels();

    if (channels != null) {
      debugPrint('作成済みAndroid通知チャンネル数: ${channels.length}');
      for (var ch in channels) {
        debugPrint('チャンネル: ${ch.id} - ${ch.name}');
      }
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

  // Android 通知権限のリクエスト（強化版）
  static Future<void> _requestAndroidPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      // Android 13 (API 33)以降の通知権限をリクエスト
      final bool? notificationPermission = await androidImplementation
          .requestNotificationsPermission();
      debugPrint('Android通知権限: $notificationPermission');

      // 通知権限の状態を確認
      final bool? enabledCheck = await androidImplementation
          .areNotificationsEnabled();
      debugPrint('Android通知権限確認: $enabledCheck');

      if (enabledCheck != true) {
        debugPrint('警告: Android通知権限が無効です。設定から有効にしてください。');
      }
    }
  }

  // 通知のタップ時の処理
  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    debugPrint('onDidReceiveNotificationResponse: $response');
  }

  // バックグラウンドで通知を受け取った時の処理
  static Future _onDidReceiveBackgroundNotificationResponse(
    NotificationResponse response,
  ) async {
    debugPrint('onDidReceiveBackgroundNotificationResponse: $response');
  }

  // 通知の送信（改良版）
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      debugPrint('通知送信開始: ID=$id, Title=$title');

      // Android 用のスタイル情報
      const androidNotificationDetails = AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'Main notification channel',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        autoCancel: true,
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

      debugPrint('通知送信完了: ID=$id');
    } catch (e) {
      debugPrint('通知送信エラー: $e');
    }
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('アラーム')),
      body: ElevatedButton(
        onPressed: () {
          SimpleNotificationService.showLocalNotification(
            '🔔 シンプル通知',
            '基本的な通知が送信されました！',
          );
        },
        child: const Text('テスト'),
      ),
    );
  }
}
