import 'package:flutter/material.dart';

class TimePickerService {
  /// 時間選択ダイアログを表示し、選択された時間を返す
  Future<TimeOfDay?> pickTime(BuildContext context, TimeOfDay currentTime) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    
    return newTime;
  }

  /// TimeOfDayを文字列形式でフォーマットする
  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// 現在時刻を取得する
  TimeOfDay getCurrentTime() {
    return TimeOfDay.now();
  }
}