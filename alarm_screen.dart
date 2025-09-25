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
      appBar: AppBar(
        title: const Text('アラーム時刻設定'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.alarm, color: Colors.blue, size: 32),
                    const SizedBox(width: 10),
                    const Text(
                      'アラーム時刻設定',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'アラームを鳴らす時刻を直接選択してください',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        '選択中のアラーム時刻: ${_timePickerService.formatTime(_time)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 180,
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    initialTimerDuration: Duration(
                      hours: _time.hour,
                      minutes: _time.minute,
                    ),
                    onTimerDurationChanged: _handleCupertinoTimeChanged,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  child: const Text('この時刻で決定', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _setAlarmTime,
                ),
                const SizedBox(height: 20),
                const NotificationScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
