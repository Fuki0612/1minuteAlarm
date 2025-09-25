import 'package:flutter/material.dart';

import './card.dart';
import '../../collection_manager.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<CardInfoClass> imageList = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final paths = await CollectionManager.getImages();
    setState(() {
      imageList = paths
          .map(
            (path) => CardInfoClass(
              name: path.split('/').last.replaceAll('.png', ''),
              url: path,
              timestamp: DateTime.now(), // 日付は今回は省略
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Collection')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: imageList.isEmpty
            ? Center(child: Text('画像はまだありません'))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: imageList.length,
                itemBuilder: (context, index) {
                  return ImageCard(info: imageList[index]);
                },
              ),
      ),
    );
  }
}
