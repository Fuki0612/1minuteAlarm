import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'collection/page.dart';

class GetScreen extends StatefulWidget {
  final String newImagePath;

  const GetScreen({Key? key, required this.newImagePath}) : super(key: key);

  @override
  State<GetScreen> createState() => _GetScreenState();
}

class _GetScreenState extends State<GetScreen> with TickerProviderStateMixin {
  late AnimationController _sparkleController;
  late AnimationController _imageController;
  late AnimationController _textController;
  late Animation<double> _sparkleAnimation;
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _textOpacityAnimation;

  bool _showImage = false;
  bool _showText = false;
  List<Offset> _sparklePositions = [];
  Timer? _sparkleTimer;

  @override
  void initState() {
    super.initState();

    // アニメーションコントローラーを初期化
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _imageController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // アニメーションを設定
    _sparkleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.easeInOut),
    );

    _imageScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.elasticOut),
    );

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    // アニメーション開始のタイマー
    _startAnimationSequence();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 不要になったため削除
  }

  void _startAnimationSequence() {
    // 1秒後にキラキラアニメーション開始
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _sparkleController.forward();
      }
    });

    // 1.5秒後に画像表示
    Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _showImage = true;
        });
        _imageController.forward();
      }
    });

    // 2秒後にテキスト表示
    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _showText = true;
        });
        _textController.forward();
      }
    });

    // 5秒後にコレクション画面に移動
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CollectionPage()),
        );
      }
    });
  }

  String _getCountryName(String imagePath) {
    if (imagePath.contains('アメリカ')) return 'アメリカ';
    if (imagePath.contains('イギリス')) return 'イギリス';
    if (imagePath.contains('フランス')) return 'フランス';
    if (imagePath.contains('ドイツ')) return 'ドイツ';
    if (imagePath.contains('スペイン')) return 'スペイン';
    if (imagePath.contains('ロシア')) return 'ロシア';
    if (imagePath.contains('日本')) return '日本';
    if (imagePath.contains('中国')) return '中国';
    return '新しい国';
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    _imageController.dispose();
    _textController.dispose();
    _sparkleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 最初のビルド時にキラキラ位置を生成
    if (_sparklePositions.isEmpty) {
      final random = Random();
      final screenSize = MediaQuery.of(context).size;
      _sparklePositions = List.generate(15, (index) {
        return Offset(
          random.nextDouble() * screenSize.width,
          random.nextDouble() * screenSize.height,
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            // キラキラエフェクト
            ...List.generate(_sparklePositions.length, (index) {
              return AnimatedBuilder(
                animation: _sparkleAnimation,
                builder: (context, child) {
                  return Positioned(
                    left: _sparklePositions[index].dx,
                    top: _sparklePositions[index].dy,
                    child: Transform.scale(
                      scale: _sparkleAnimation.value,
                      child: Opacity(
                        opacity: (1.0 - _sparkleAnimation.value).clamp(
                          0.0,
                          1.0,
                        ),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade300,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.yellow.withOpacity(0.6),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // メインコンテンツ
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 獲得メッセージ
                  if (_showText)
                    AnimatedBuilder(
                      animation: _textOpacityAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacityAnimation.value,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.yellow.shade400,
                                      Colors.orange.shade400,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.yellow.withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  '🎉 新しい国を獲得！ 🎉',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        );
                      },
                    ),

                  // 画像
                  if (_showImage)
                    AnimatedBuilder(
                      animation: _imageScaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _imageScaleAnimation.value,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: Colors.yellow.withOpacity(0.4),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                widget.newImagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade300,
                                    child: const Center(
                                      child: Icon(
                                        Icons.flag,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 30),

                  // 国名
                  if (_showText)
                    AnimatedBuilder(
                      animation: _textOpacityAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacityAnimation.value,
                          child: Text(
                            _getCountryName(widget.newImagePath),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 10,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 50),

                  // タップして閉じる案内
                  if (_showText)
                    AnimatedBuilder(
                      animation: _textOpacityAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacityAnimation.value * 0.7,
                          child: const Text(
                            '画面をタップして続行',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
