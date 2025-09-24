import 'package:flutter/material.dart';
import 'detail.dart';

class CardInfoClass {
  final String name;
  final String url;
  final DateTime timestamp;

  CardInfoClass({
    required this.name,
    required this.url,
    required this.timestamp,
  });
}

class ImageCard extends StatelessWidget {
  final CardInfoClass info;
  const ImageCard({super.key, required this.info});

  void _showDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ImageDetailDialog(info: info),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetail(context),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Hero を付けて詳細画面との遷移を滑らかにする
            Hero(
              tag: info.url,
              child: Image.asset(
                info.url,
                fit: BoxFit.cover,
                semanticLabel: info.name,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),

            // オーバーレイ（グラデ）＋中央テキスト
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      info.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${info.timestamp.toLocal().year}/${info.timestamp.toLocal().month}/${info.timestamp.toLocal().day}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ダイアログ本体（画像拡大＋詳細表示）
class ImageDetailDialog extends StatelessWidget {
  final CardInfoClass info;
  const ImageDetailDialog({super.key, required this.info});

  String _formattedDate(DateTime dt) {
    final local = dt.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y/$m/$d';
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _formattedDate(info.timestamp);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // ダイアログの最大サイズを画面に合わせて制限
          maxWidth: 800,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ヘッダ（タイトルと閉じるボタン）
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      info.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // 画像（インタラクティブにズーム可能）
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: double.infinity,
                  // 高さは画面サイズに依存する
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Hero(
                    tag: info.url,
                    child: InteractiveViewer(
                      maxScale: 3.0,
                      minScale: 0.8,
                      child: Image.asset(
                        info.url,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 56,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 詳細テキスト（スクロール可能に）
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '入手日: $dateStr',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    // 必要ならここに説明文を足す（現状は未定義）
                    Text(
                      'ここに説明を追加',
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),

            // 下部ボタン（閉じる）
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('閉じる'),                    ),
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