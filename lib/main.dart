import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_application_1/pages/home/page.dart';

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
      case 1:
        return const Center(child: Text('アラーム画面（未実装）'));
      case 2:
        return const Center(child: Text('チャット画面（未実装）'));
      case 3:
        return const Center(child: Text('コレクション画面（未実装）'));
      case 4:
        return const Center(child: Text('ゲーム画面（未実装）'));
      default:
        return Center(child: Text('Page $_selectedIndex'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages(),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        color: Colors.white,
        backgroundColor: Colors.blue,
        activeColor: Colors.white,
        initialActiveIndex: _selectedIndex,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.alarm, title: 'Alarm'),
          TabItem(icon: Icons.chat, title: 'Chat'),
          TabItem(icon: Icons.collections, title: 'Collection'),
          TabItem(icon: Icons.gamepad, title: 'Game'),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
