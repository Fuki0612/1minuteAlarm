import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../pages/home/page.dart';

void main() {
  runApp(const TitlePage());
}

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyTitlePage(title: 'Flutter Practice Page'),
    );
  }
}

class MyTitlePage extends StatefulWidget {
  const MyTitlePage({super.key, required this.title});

  final String title;

  @override
  State<MyTitlePage> createState() => _MyTitlePageState();
}

class _MyTitlePageState extends State<MyTitlePage> {
  int _selectedIndex = 0;

  Widget _pages() {
    switch (_selectedIndex) {
      case 0: // Home
        return HomePage();
      default:
        return Center(child: Text('Page $_selectedIndex'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages(),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.flip,
        color: Color(0xFFFFAAAA),
        backgroundColor: Color(0xFFEEEEEE),
        activeColor: Color(0xFFEE0000),
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.alarm, title: 'Alarm'),
          TabItem(icon: Icons.chat, title: 'Chat'),
          TabItem(icon: Icons.collections, title: 'Collection'),
          TabItem(icon: Icons.gamepad, title: 'Game'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
