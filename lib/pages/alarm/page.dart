import 'package:flutter/material.dart';
import 'dart:async';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  TimeOfDay? _selectedTime;
  bool _isAlarmSet = false;
  Timer? _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateCurrentTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCurrentTime();
      _checkAlarm();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateCurrentTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}:'
          '${now.second.toString().padLeft(2, '0')}';
    });
  }

  void _checkAlarm() {
    if (_isAlarmSet && _selectedTime != null) {
      final now = DateTime.now();
      if (now.hour == _selectedTime!.hour && now.minute == _selectedTime!.minute) {
        _showAlarmDialog();
        setState(() {
          _isAlarmSet = false;
        });
      }
    }
  }

  void _showAlarmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('アラーム'),
          content: const Text('設定した時刻になりました！'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _toggleAlarm() {
    if (_selectedTime != null) {
      setState(() {
        _isAlarmSet = !_isAlarmSet;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(