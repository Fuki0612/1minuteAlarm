import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int score = 0;
  int remainingSeconds = 60; // 残り時間(秒)
  Timer? _timer;
  final _player = AudioPlayer();

  void _increaseScore() {//スコアを増やし再描画
    setState(() {
      score++;
    });
  }

  @override
  void initState() { //初期化してタイマーを開始
    super.initState();
    _startCountdown();
  }

  Future<void> _startCountdown() async {//タイマーの内容
    await _player.play(AssetSource('sounds/gamestart.mp3'));
    await Future.delayed(const Duration(milliseconds: 100));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        t.cancel();
        // ここでゲーム終了の処理とかはここに
      }
    });
  }

  String _formatTime(int totalSeconds) {//分、秒の表記法
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override//画面から離れたときなどにタイマーの処理を止める処理
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {//UIとスコアとタイマーを表示
    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body: Stack(
        children: [
          Center(
            child: Stack(
              alignment:Alignment.center,
              children:[
                Image.asset(
                  'lib/images/clock.png',
                  width:450,
                  height:450,
                ),
                Image.asset(
                  'lib/images/chara.png',
                  width:250,
                  height:250,
                ),
              ]
            )
          ),
          // 右上にスコアとタイマーを縦並びで表示
          Positioned(
            right: 20,
            top: 20,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Score: $score',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Time: ${_formatTime(remainingSeconds)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      // 残り10秒で赤くする演出
                      color: remainingSeconds <= 10 ? Colors.red : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(//試しにボタンを押すとスコアが増えるように
        onPressed: _increaseScore,
        child: const Icon(Icons.add),
      ),
    );
  }
}