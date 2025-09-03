import 'package:flutter/material.dart';
import 'functions/notification.dart';
import 'functions/timeselect.dart';

void init() async {
  // 通知サービスの初期化
  await SimpleNotificationService.initialize();
}

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  TimeOfDay _time = TimeOfDay.now();
  final TimePickerService _timePickerService = TimePickerService();

  Future<void> _handleTimeSelection() async {
    final newTime = await _timePickerService.pickTime(context, _time);
    if (newTime != null) {
      setState(() => _time = newTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                child: Text(_timePickerService.formatTime(_time)),
                onPressed: _handleTimeSelection,
              ),
            ),
            const Expanded(
              child: NotificationScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
