import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
import 'score_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  //初期値を定義
  int score = 0;
  int remainingSeconds = 60;
  int initcount = 3;
  int hit = 13;

  Timer? _initTimer;
  Timer? _timer;
  Timer? _resetTimer;

  final _player = AudioPlayer();
  final _rand = Random();

  bool _started = false;
  bool _counted = false;
  bool _explained = false;
  bool _isFinished = false;
  

  List<Color> colors = List.generate(12, (i) =>i ==0?Colors.green:Colors.black);
  final List<int> picks = List.generate(12, (i)=>i);

  final List<String> _hitSounds = [
    'sounds/hit1.mp3',
    'sounds/hit2.mp3',
    'sounds/hit3.mp3',
    'sounds/time.mp3',
    'sounds/bomb.mp3',
  ];

  void _increaseScore(int i) {//スコアを増やし再描画
    setState(() {
      score += i;
    });
  }

  Widget numberButton(int index,Color color){//ボタンの色と挙動
    if (color == Colors.yellow){
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap:(){
          hit = index -1;
          _playHitSfx(_hitSounds[3]);
          setState(() {
            remainingSeconds ++;
          });
          _nextTarget();
        },
        child:Text(
          "⌛️",
          style: TextStyle(
            fontSize: 50,
          )
        ),
      );
    }else if(color == Colors.purple){
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap:(){
          hit = index -1;
          _playHitSfx(_hitSounds[4]);
          setState(() {
            score = score -5;
          });
          _nextTarget();
        },
        child:Text(
          "💣",
          style: TextStyle(
            fontSize: 50,
          )
        ),
      );
    }else{
      return GestureDetector (
        behavior: HitTestBehavior.translucent,
        onTap: () {
          hit = index -1;
          if (color == Colors.black){
            }else if (color == Colors.green){
             _playHitSfx(_hitSounds[0]);
             _increaseScore(1);
            }else if (color == Colors.blue){
              _playHitSfx(_hitSounds[1]);
              _increaseScore(2);
            }else if(color == Colors.red){
              _playHitSfx(_hitSounds[2]);
               _increaseScore(-1);
            }
          if (color != Colors.black){
             _nextTarget();
          }
        },
        child: Text(
          "$index",
          style: TextStyle(
            fontSize:50,
            color: color,
          )
        ),
      );
    }
  }

  List<Widget> buildClock(double radious,List colors){//ボタンを配置
    final angleStep = 2*pi/12;
    const startOffset = -pi/3;
    return List.generate(12,(index){
      final angle = angleStep * index + startOffset;
      final dx = radious * cos(angle);
      final dy = radious * sin(angle);
      return Transform.translate(
        offset: Offset(dx,dy),
        child: numberButton(index+1,colors[index] ),
      );
    });
  }

  void _nextTarget(){//黒じゃないのを押すと呼ばれる
    picks.shuffle(_rand);
    if (score <= 9) {
      setState((){
        colors.fillRange(0,12,Colors.black);
        colors[picks[0]] = Colors.green;
      });
    }else if(score<=19){
      setState(() {
        colors.fillRange(0,12,Colors.black);
        colors[picks[0]] = Colors.green;
        colors[picks[1]] = Colors.blue;
        colors[picks[2]] = Colors.red;
      });
    }else if (score>=20) {
      setState((){
        colors[hit] = Colors.black;
      });
      if (colors.every((c) =>
          c.toARGB32() == Colors.black.toARGB32() ||
          c.toARGB32() == Colors.red.toARGB32() ||
          c.toARGB32() ==Colors.purple.toARGB32())
        ){setState(() {
            colors.fillRange(0,12,Colors.black);
            colors[picks[0]] = Colors.green;
            colors[picks[1]] = Colors.blue;
            colors[picks[2]] = Colors.red;
            colors[picks[3]] = Colors.yellow;
            colors[picks[4]] = Colors.purple;
            _boardReset();
          });
      }
    }
  }

  void reset() {//scorepageで呼びリセット
    setState((){
      score = 0;
      remainingSeconds = 60;
      initcount = 3;
      hit = 13;
      _started = false;
      _explained = false;
      _counted = false;
      _isFinished = false;
      colors = List.generate(12, (i) =>i ==0?Colors.green:Colors.black);
    });
  }

  void _playHitSfx(String assetPath) {//音を重ねて鳴らせる
    final p = AudioPlayer();
    p.play(AssetSource(assetPath)).catchError((_) {});
    p.onPlayerComplete.first.then((_) => p.dispose());
  }
  
  void _initCount(){//最初の3,2,1のカウントダウン
    _initTimer = Timer.periodic(Duration(seconds:1),(t) {
      if (initcount > 1) {
        _player.play(AssetSource('sounds/start.mp3'));
        setState((){
          initcount--;
        });
      }else {
        _startCountdown();
        t.cancel();
        setState(() {
          _counted = true;
        });
      }
    });
  }



  Future<void> _startCountdown() async {//タイマーの内容
    await _player.play(AssetSource('sounds/start.mp3'));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        t.cancel();
        _resetTimer?.cancel();
        setState(() {
          _isFinished = true; // タイマー終了を通知
        });
        // ここでゲーム終了の処理とかはここに
      }
    });
  }

  void _boardReset() {//2秒後に盤面をリセット
    _resetTimer?.cancel();
    _resetTimer = Timer.periodic(const Duration(seconds: 2),(t){
      picks.shuffle(_rand);
      setState(() {
        colors.fillRange(0,12,Colors.black);
        colors[picks[0]] = Colors.green;
        colors[picks[1]] = Colors.blue;
        colors[picks[2]] = Colors.red;
        colors[picks[3]] = Colors.yellow;
        colors[picks[4]] = Colors.purple;
      });
      t.cancel();
      if(score >=20){
        _boardReset();
      }
    });
  }

  @override//画面から離れたときなどにタイマーの処理を止める処理
  void dispose() {
    _timer?.cancel();
    _resetTimer?.cancel();
    _initTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {//UIとスコアとタイマーを表示
    if (_isFinished){
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)=>ScorePage(score: score,reset:reset,),
          ),
        );
      } );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body:Stack(
        alignment:Alignment.center,
          children: [
           Center(
              child:(){
                if(!_started){
                  return ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _started = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape:CircleBorder(),
                      minimumSize: Size(250,250),
                    ),
                    child:Text('ゲームのタイトル',style: TextStyle(fontSize: 30),),
                  );
                }else if(!_explained){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("🟩: +1点",style: TextStyle(fontSize: 30)),
                      const Text("🟦: +2点",style: TextStyle(fontSize: 30)),
                      const Text("🟥: -1点",style: TextStyle(fontSize: 30)),
                      const Text("⌛️: +1s",style: TextStyle(fontSize: 30)),
                      const Text("💣: -5点",style: TextStyle(fontSize: 30)),
                      ElevatedButton(
                       onPressed: (){
                         _initCount();
                         setState(() {
                         _explained=true;
                       }); }, 
                      child: Text('start',style: TextStyle(fontSize: 30))
                     ),
                    ],);
                }else if (!_counted){
                 return Text(
                   '$initcount',
                   style:TextStyle(fontSize:48),
                   );
               }else{
                 return Stack(
                   alignment: Alignment.center,
                   children: [
                     ClipOval(
                       child: Image.asset(
                         'lib/images/chara.png',
                          width: 400,
                          height: 400,
                          fit: BoxFit.cover,
                        )
                      ,),
                    ...buildClock(200,colors),
                   ],
                 );
               }
             }(),
            ),
          // 右上にスコアとタイマーを横並びで表示
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