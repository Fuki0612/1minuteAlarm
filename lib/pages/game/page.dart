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
  //各関数で使う値を定義
  int score = 0;
  int remainingSeconds = 60;
  int initcount = 3;

  int _target = 0;
  List<int> _target2 = [0,1,2];
  List<int> _target3 =[0,1,2];
  List<int>_target4 = [0,1,2,3,4];

  final _items = List<int>.generate(12, (i)=> i+1);
  final _rand = Random();
  Timer? _timer;
  Timer? _resetTimer;
  Timer? _initTimer;
  final _player = AudioPlayer();
  bool _isFinished = false;
  bool _started = false;
  bool _counted = false;
  final List<String> _hitSounds = [
    'sounds/hit1.mp3',
    'sounds/hit2.mp3',
    'sounds/hit3.mp3',
    'sounds/hit4.mp3',
  ];
  
  void reset() {
    setState((){
      score = 0;
      remainingSeconds = 60;
      initcount = 3;
      _target = 0;
      _target2 = [0,1,2];
      _target3 =[0,1,2];
      _target4 = [0,1,2,3,4];
      _isFinished = false;
      _started = false;
      _counted = false;
    });
  }

 void _increaseScore() {//スコアを増やし再描画
    setState(() {
      score++;
    });
    if (score == 10) {
      _player.play(AssetSource('sounds/levelup.mp3'));
    }
    if (score == 22) {
       _player.play(AssetSource('sounds/levelup.mp3'));
      _startReset();
    }
    if (score == 34){
       _player.play(AssetSource('sounds/levelup.mp3'));
      _startReset2();
    }
  }

  void _playHitSfx(String assetPath) {//hit時の効果音
    final p = AudioPlayer();
    p.play(AssetSource(assetPath)).catchError((_) {});
    p.onPlayerComplete.first.then((_) => p.dispose());
  }

  void _nextTarget(){//targetを変え再描画
    int next = _rand.nextInt(12);
    while (next == _target ){
      next = _rand.nextInt(12);
    }
    setState(() => _target = next);
  }

  void _onHit(int index) {//点数が入りtargetを変える
    if (index == _target){
      final sound = _hitSounds[_rand.nextInt(_hitSounds.length)];
      _playHitSfx(sound);
      _increaseScore();
      _nextTarget();
    }
  }

  void _nextTarget2() {//target３つを変え再描画
    List<int> numbers = List.generate(12, (i) => i );
    numbers.shuffle(Random());
    List<int> next2 = numbers.take(3).toList();
    setState(()=> _target2 = next2);
  }

   void _onHit2(int index) {//点数が入り、的がなくなっていたら的を補充
    if (_target2.contains(index)){
      final sound = _hitSounds[_rand.nextInt(_hitSounds.length)];
      _playHitSfx(sound);
      _target2.remove(index);
      _increaseScore();
    }
    if (_target2.isEmpty) {
      _nextTarget2();
    }
   }

  void _startReset() {//時間経過でマトが移動
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 2), (){//マトが移動する間隔
      _nextTarget3();
    });
  }

  void _nextTarget3() {//target３つを変え再描画
    _resetTimer?.cancel();
    _resetTimer = null;
    List<int> numbers = List.generate(12, (i) => i );
    numbers.shuffle(Random());
    List<int> next3 = numbers.take(3).toList();
    setState(()=> _target3 = next3);
    _startReset();
  }

  void _onHit3(int index) {//点数が入り的がなかったら的を補充
    if (_target3.contains(index)){
      final sound = _hitSounds[_rand.nextInt(_hitSounds.length)];
      _playHitSfx(sound);
      _target3.remove(index);
      _increaseScore();
    }
    if (_target3.isEmpty) {
      _nextTarget3();
    }
  }

  void _startReset2() {//時間経過でマトが移動
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 3), (){//マトが移動する間隔
      _nextTarget4();
    });
  }

  void _nextTarget4() {//target5つを変え再描画
    _resetTimer?.cancel();
    _resetTimer = null;
    List<int> numbers = List.generate(12, (i) => i );
    numbers.shuffle(Random());
    List<int> next4 = numbers.take(5).toList();
    setState(()=> _target4 = next4);
    _startReset2();
  }

  void _onHit4(int index) {//点数が入り的がなければ補充
    if (_target4.contains(index)){
      final sound = _hitSounds[_rand.nextInt(_hitSounds.length)];
      _playHitSfx(sound);
      _target4.remove(index);
      _increaseScore();
    }
    if (_target4.isEmpty) {
      _nextTarget4();
    }
  }

  //時計の生成
  List<Widget> _buildCircleItems(double radius) {
    final items = List.generate(12, (i) => i + 1);
    final angleStep = 2 * pi / items.length;

    return List.generate(items.length, (index) {//形を時計に
      final angle = angleStep * index - pi / 3; 
      final dx = radius * cos(angle);
      final dy = radius * sin(angle);

      bool isActive;
      if (score <=9){
        isActive = _target == index;
      }else if (score <=21){
        isActive = _target2.contains(index);
      }else if (score <=33){
        isActive = _target3.contains(index);
      }else {
        isActive = _target4.contains(index);
      }

      return Align(//時計の配置
        alignment: Alignment.center,
        child: Transform.translate(
          offset: Offset(dx, dy), 
          child: GestureDetector(
            onTap:() {
              if (score <= 9){
                _onHit(index);
              } else if (score <=21) {
                _onHit2(index);
              }else if (score <=33){
                _onHit3(index);
              }else {
                _onHit4(index);
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Text(
              '${_items[index]}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w400,
                color: isActive ? Colors.red : Colors.black87,
                shadows: isActive
                    ? const [Shadow(blurRadius: 8, offset: Offset(0, 0))]
                    : null,
              ),
            ),
          )
        ),
      );
    });
  }
  void _initCount(){
    _initTimer = Timer.periodic(Duration(seconds:1),(timer) {
      if (initcount > 1) {
        _player.play(AssetSource('sounds/321.mp3'));
        setState((){
          initcount--;
        });
      }else {
        _startCountdown();
        timer.cancel();
        setState(() {
          _counted = true;  // ← setStateの中に入れる
        });
      }
    });
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
        _resetTimer?.cancel();
        setState(() {
          _isFinished = true; // タイマー終了を通知
        });
        // ここでゲーム終了の処理とかはここに
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
       children: [
          Center(
            child:(){
              if(!_started){
                return ElevatedButton(
                  onPressed: (){
                    _initCount();
                    setState(() {
                      _started = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape:CircleBorder(),
                    minimumSize: Size(250,250),
                  ),
                  child:Text('ゲームスタート',style: TextStyle(fontSize: 30),),
                );
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
                  ..._buildCircleItems(200),
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