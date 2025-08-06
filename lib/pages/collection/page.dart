import 'package:flutter/material.dart';
import './card.dart';

class CollectionPage extends StatelessWidget {
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
          itemCount: 1, // For now, just one test item
          itemBuilder: (context, index) {
            return ImageCard(
              info: CardInfoClass(
                name: 'Sample Image',
                url: 'lib/images/collections/test.png',
                timestamp: DateTime.now(),
              ),
            );
          },
        ),
      ),
    );
  }
}
