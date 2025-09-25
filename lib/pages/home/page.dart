import 'package:flutter/material.dart';

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../../collection_manager.dart';
import '../collection/page.dart';
import 'dart:math';
import '../../services/alarm_service.dart';
import '../get_screen.dart';

class HomePage extends StatefulWidget {
  final String alarmTime;
  final Function(String) onAlarmTimeChanged;
  const HomePage({
    Key? key,
    required this.alarmTime,
    required this.onAlarmTimeChanged,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentTime = '';
  DateTime _alarmDateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Timer? _timer;
  bool _isButtonEnabled = false;
  bool _alarmPlaying = false;
  bool _alarmStopped = false; // アラームが停止されたかどうかのフラグ
  AudioPlayer? _alarmPlayer;

  DateTime _parseAlarmTime(String alarmTimeString) {
    final parts = alarmTimeString.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  void _updateTime() async {
    final now = DateTime.now();
    final difference = now.difference(_alarmDateTime).inSeconds;

    setState(() {
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}:'
          '${now.second.toString().padLeft(2, '0')}';

      // アラーム時刻から1分間（0秒～59秒）のみボタンを有効にし、
      // かつアラームが停止されていない場合のみ
      _isButtonEnabled =
          (difference >= 0 && difference <= 59) && !_alarmStopped;
    });

    // アラーム時刻になったらアラーム音を1分間ループ再生
    if (!_alarmPlaying &&
        now.year == _alarmDateTime.year &&
        now.month == _alarmDateTime.month &&
        now.day == _alarmDateTime.day &&
        now.hour == _alarmDateTime.hour &&
        now.minute == _alarmDateTime.minute &&
        now.second == _alarmDateTime.second) {
      _alarmPlaying = true;
      _alarmStopped = false; // アラーム開始時にリセット
      _playAlarmSoundLoop();
      // アラーム通知を表示
      AlarmService.showAlarmNotification();
    }
    // アラーム時刻から1分以上経過したら停止
    if (_alarmPlaying && difference > 60) {
      _alarmPlaying = false; // 先にフラグを false にしてループを停止
      await _stopAlarmSound();
      await AlarmService.cancelAllNotifications(); // 通知もキャンセル
      _alarmStopped = false; // 次のアラームのためにリセット
    }
  }

  Future<void> _playAlarmSoundLoop() async {
    try {
      _alarmPlayer = AudioPlayer();
      // ループ設定を削除して、手動でループ制御
      await _alarmPlayer!.play(AssetSource('sounds/alarm.mp3'));
      print('アラーム音を開始しました'); // デバッグ用ログ

      // 音楽が終了したら再度再生する（手動ループ）
      _alarmPlayer!.onPlayerComplete.listen((event) {
        if (_alarmPlaying && _alarmPlayer != null) {
          _alarmPlayer!.play(AssetSource('sounds/alarm.mp3'));
        }
      });
    } catch (e) {
      print('アラーム音開始エラー: $e');
    }
  }

  Future<void> _stopAlarmSound() async {
    try {
      if (_alarmPlayer != null) {
        // 音楽を停止
        await _alarmPlayer!.stop();
        await _alarmPlayer!.release(); // release()を使用してリソースを解放
        await _alarmPlayer!.dispose();
        _alarmPlayer = null;
        print('アラーム音を停止しました'); // デバッグ用ログ
      }
    } catch (e) {
      print('アラーム音停止エラー: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _alarmDateTime = _parseAlarmTime(widget.alarmTime);
    _alarmStopped = false;
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _updateTime();
    });
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.alarmTime != oldWidget.alarmTime) {
      _alarmDateTime = _parseAlarmTime(widget.alarmTime);
      // アラーム時刻が変更されたら状態をリセット
      _alarmStopped = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    // アプリ終了時にもアラーム音を確実に停止
    if (_alarmPlayer != null) {
      _stopAlarmSound();
    }
    super.dispose();
  }

  // コレクション画像候補
  final List<String> allImages = [
    'lib/images/collections/アメリカ.png',
    'lib/images/collections/イギリス.png',
    'lib/images/collections/フランス.png',
    'lib/images/collections/ドイツ.png',
    'lib/images/collections/スペイン.png',
    'lib/images/collections/ロシア.png',
    'lib/images/collections/日本.png',
    'lib/images/collections/中国.png',
  ];

  Future<void> _getImageAndNavigate(BuildContext context) async {
    print('アラームを止めるボタンが押されました'); // デバッグ用ログ

    // アラームを停止
    if (_alarmPlaying) {
      print('アラーム音を停止中...'); // デバッグ用ログ
      _alarmPlaying = false; // 先にフラグを false にしてループを停止
      await _stopAlarmSound();
      // アラーム通知もキャンセル
      await AlarmService.cancelAllNotifications();
    }

    // このアラームでは既にボタンが押されたことを記録
    setState(() {
      _alarmStopped = true;
    });

    // 既に獲得済みの画像を取得
    final gotImages = await CollectionManager.getImages();
    // 未獲得画像リスト
    final notGotImages = allImages
        .where((img) => !gotImages.contains(img))
        .toList();

    String? selectedImage;
    if (notGotImages.isNotEmpty) {
      // ランダムで1枚選ぶ
      final random = Random();
      selectedImage = notGotImages[random.nextInt(notGotImages.length)];
      await CollectionManager.addImage(selectedImage);

      // 画像獲得演出画面を表示
      if (mounted) {
        await Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                GetScreen(newImagePath: selectedImage!),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    }

    // コレクション画面に遷移
    if (mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const CollectionPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            // SingleChildScrollView内に直接Columnを配置
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '現在時刻',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      _currentTime,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // アラーム時刻は表示のみ（タップ不可）
              Text(
                'アラーム時刻: ${widget.alarmTime}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled ? Colors.red : Colors.grey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _isButtonEnabled
                    ? () async {
                        await _getImageAndNavigate(context);
                      }
                    : null,
                child: Text(
                  'アラームを止める',
                  style: TextStyle(
                    fontSize: 18,
                    color: _isButtonEnabled ? Colors.white : Colors.white54,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Image.asset('lib/images/chara.png', width: 200),
            ],
          ),
        ),
      ),
    );
  }
}
