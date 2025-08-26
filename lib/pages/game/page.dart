import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

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

List<Widget> _buildCircleItems(double radius) {
  final items = List.generate(12, (i) => i + 1);
  final angleStep = 2 * pi / items.length;

  return List.generate(items.length, (index) {//時計の生成
    final angle = angleStep * index - pi / 3; 
    final dx = radius * cos(angle);
    final dy = radius * sin(angle);

    return Align(//時計の配置
      alignment: Alignment.center,
      child: Transform.translate(
        offset: Offset(dx, dy), 
        child: Text(
         '${items[index]}',
         style: const TextStyle(fontSize: 32)
        ),
      ),
    );
  });
}

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
          Center(//キャラの画像を円形の枠で表示
            child:ClipOval(
               child: Image.asset(
                 'lib/images/chara.png',
                 width: 400,
                 height: 400,
                 fit: BoxFit.cover,
                 ),
              )
          ),
          ..._buildCircleItems(200),
          // 右上にスコアとタイマーを縦並びで表示
          Positioned(
            right: 20,
            top: 20,
            child: SafeArea(
              child: Row(
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
                  const SizedBox(width: 6),
                  Text(
                    'Time: ${remainingSeconds.toString()}',
                    style: TextStyle(
                      fontSize: 24,
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
    );
  }
}