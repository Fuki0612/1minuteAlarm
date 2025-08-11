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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageDetailPage(info: info)),
        );
      },
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image that fills the entire card
            Image.asset(
              info.url,
              fit: BoxFit.cover,
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
            // Overlay with centered text
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top text
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
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
                  ),
                  // Bottom text
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
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
