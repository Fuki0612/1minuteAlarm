import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'pages/home/page.dart';
import 'pages/alarm/page.dart';
import 'pages/collection/page.dart';
import 'pages/game/page.dart';
import 'pages/chat/page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      home: const MyTitlePage(title: '1 minute alarm'),
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
      case 1: // Alarm
        return AlarmPage();
      case 2: // Chat
        return ChatPage();
      case 3: // Collection
        return CollectionPage();
      case 4: // Game
        return GamePage();
      default:
        return Center(child: Text('Page $_selectedIndex'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages(),
      bottomNavigationBar: ConvexAppBar(
        // タイトル タスク.1
        items: [
          // タイトル タスク.2
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
