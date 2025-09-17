import 'package:flutter/material.dart';
import './card.dart';

class CollectionPage extends StatelessWidget {
  // ここで画像カード情報リストを作成
  final List<CardInfoClass> imageList = [
    CardInfoClass(
      name: 'Sample Image 1',
      url: 'lib/images/collections/test.png',
      timestamp: DateTime.now(),
    ),
    CardInfoClass(
      name: 'Sample Image 2',
      url: 'lib/images/collections/test.png',
      timestamp: DateTime.now(),
    ),
    CardInfoClass(
      name: 'Sample Image 3',
      url: 'lib/images/collections/test.png',
      timestamp: DateTime.now(),
    ),
    CardInfoClass(
      name: 'Sample Image 4',
      url: 'lib/images/collections/test.png',
      timestamp: DateTime.now(),
    ),
    
CardInfoClass(
      name: 'Sample Image 5',
      url: 'lib/images/collections/test.png',
      timestamp: DateTime.now(),
    ),
    
CardInfoClass(
      name: 'Sample Image 6',
      url: 'lib/images/collections/test.png',
      timestamp: DateTime.now(),
    ),
    
CardInfoClass(
      name: 'Sample Image 7',
      url: 'lib/images/collections/test.png',
      timestamp: DateTime.now(),
    ),
    
CardInfoClass(
      name: 'Sample Image ',
      url: 'lib/images/collections/test.png',
      timestamp: DateTime.now(),
    ),
    
CardInfoClass(
      name: 'Sample Image 9',
      url: 'lib/images/collections/test.png',
      timestamp: DateTime.now(),
    ),
    
CardInfoClass(
      name: 'Sample Image 10',
      url: 'lib/images/collections/test.png',
      timestamp: DateTime.now(),
    ),
    


    // 必要に応じてここにどんどん追加
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Collection')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1.0,
          ),
          itemCount: imageList.length, // リストの長さに合わせて自動
          itemBuilder: (context, index) {
            return ImageCard(
              info: imageList[index], // indexでリストから取得
            );
          },
        ),
      ),
    );
  }
}