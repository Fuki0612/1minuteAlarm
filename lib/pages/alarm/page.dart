import 'package:flutter/material.dart';
import 'notification.dart';

void init() async {
  // 通知サービスの初期化
  await SimpleNotificationService.initialize();
}

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationScreen(),
    );
  }
}
