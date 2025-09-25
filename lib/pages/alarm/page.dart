import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/pages/alarm/functions/timeselect.dart';
import 'package:flutter_application_1/pages/alarm/functions/notification.dart';

class AlarmScreen extends StatefulWidget {
  final String alarmTime;
  final Function(String) onAlarmTimeChanged;

  const AlarmScreen({
    Key? key,
    required this.alarmTime,
    required this.onAlarmTimeChanged,
  }) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late TimeOfDay _time;
  final TimePickerService _timePickerService = TimePickerService();

  @override
  void initState() {
    super.initState();
    // alarmTime文字列（"12:00:00"形式）をTimeOfDayに変換
    _time = _parseTimeString(widget.alarmTime);
  }

  // "12:00:00"形式の文字列をTimeOfDayに変換
  TimeOfDay _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // TimeOfDayを"12:00:00"形式の文字列に変換
  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }

  void _handleCupertinoTimeChanged(Duration duration) {
    setState(() {
      _time = TimeOfDay(
        hour: duration.inHours,
        minute: duration.inMinutes % 60,
      );
    });
  }

  void _setAlarmTime() {
    final timeString = _formatTimeOfDay(_time);
    widget.onAlarmTimeChanged(timeString);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'アラーム時刻を ${_timePickerService.formatTime(_time)} に設定しました',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // タイトル部分
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.alarm, color: Colors.blue, size: 28),
                        const SizedBox(width: 8),
                        const Text(
                          'アラーム時刻設定',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'アラームを鳴らす時刻を選択してください',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // 現在選択中の時刻表示
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue, size: 20),
                    const SizedBox(height: 8),
                    Text(
                      _timePickerService.formatTime(_time),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Text(
                      '選択中のアラーム時刻',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
              ),

              // 時刻選択ピッカー
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    initialTimerDuration: Duration(
                      hours: _time.hour,
                      minutes: _time.minute,
                    ),
                    onTimerDurationChanged: _handleCupertinoTimeChanged,
                  ),
                ),
              ),

              // ボタン部分
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _setAlarmTime,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'この時刻でアラームを設定',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          SimpleNotificationService.showLocalNotification(
                            '🔔 テスト通知',
                            'アラーム通知のテストです',
                          );
                        },
                        icon: const Icon(
                          Icons.notifications_outlined,
                          size: 18,
                        ),
                        label: const Text('通知テスト'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
