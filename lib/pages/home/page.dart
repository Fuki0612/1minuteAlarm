import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentTime = '';
  // アラーム時刻を保持する変数
  String _alarmTime = "12:00:00";
  Timer? _timer;

  void _updateTime() {
    final now = DateTime.now(); // 現在の時刻を取得
    setState(() {
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:' //Hourの表示
          '${now.minute.toString().padLeft(2, '0')}:' //Minuteの表示
          '${now.second.toString().padLeft(2, '0')}';
    });
  }

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
              // 既存の現在時刻表示コンテナ
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

              Text(
                'アラーム時刻: $_alarmTime',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // アラームを設定する処理
                },
                child: const Text('画像を表示'),
              ),

              Image.asset('lib/images/chara.png', width: 200),
            ],
          ),
        ),
      ),
    );
  }
}
