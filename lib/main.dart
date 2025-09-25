import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_application_1/pages/home/page.dart';
import 'pages/alarm/page.dart';
import 'pages/collection/page.dart';
import 'pages/game/page.dart';
import 'pages/chat/page.dart';
import 'pages/alarm/functions/notification.dart';
import 'services/alarm_service.dart';
import 'pages/chat/gpt.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 通知サービスを初期化
  await SimpleNotificationService.initialize();

  // アラーム通知サービスを初期化
  await AlarmService.initialize();

  // ChatGPTサービスを初期化
  ChatGPTService.initialize();

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
  String alarmTime = '12:00:00';

  Widget _pages() {
    switch (_selectedIndex) {
      case 0: // Home
        return HomePage(
          alarmTime: alarmTime,
          onAlarmTimeChanged: (newTime) {
            setState(() {
              alarmTime = newTime;
            });
          },
        );
      case 1: // Alarm
        return AlarmScreen(
          alarmTime: alarmTime,
          onAlarmTimeChanged: (newTime) {
            setState(() {
              alarmTime = newTime;
            });
          },
        );
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
