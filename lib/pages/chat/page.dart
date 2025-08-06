import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './function.dart';
import './message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  static const String _messagesKey = 'chat_messages';

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // メッセージをローカルストレージから読み込み
  Future<void> _loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = prefs.getStringList(_messagesKey) ?? [];

      setState(() {
        _messages.clear();
        _messages.addAll(
          messagesJson.map((json) => ChatMessage.fromJson(jsonDecode(json))),
        );
      });
    } catch (e) {
      print('メッセージの読み込みに失敗しました: $e');
    }
  }

  // メッセージをローカルストレージに保存
  Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = _messages
          .map((message) => jsonEncode(message.toJson()))
          .toList();
      await prefs.setStringList(_messagesKey, messagesJson);
    } catch (e) {
      print('メッセージの保存に失敗しました: $e');
    }
  }

  // チャットログをクリア
  Future<void> _clearMessages() async {
    setState(() {
      _messages.clear();
    });
    await _saveMessages();
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // メッセージコントローラーをクリア
    _messageController.clear();

    setState(() {
      // ユーザーのメッセージを追加
      _messages.add(
        ChatMessage(text: text.trim(), isUser: true, timestamp: DateTime.now()),
      );
    });

    // メッセージを保存
    await _saveMessages();

    // メッセージリストの最下部にスクロール
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チャット'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _clearMessages();
            },
            tooltip: 'チャットログをクリア',
          ),
        ],
      ),
      body: Column(
        children: [
          // メッセージリスト
          Expanded(
            child:
                _messages
                    .isEmpty // メッセージがない時の表示
                ? const Center(
                    child: Text(
                      'メッセージを送信してチャットを開始しましょう！',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return MessageBubble(message: message);
                    },
                  ),
          ),

          // メッセージ入力欄
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 6,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'メッセージを入力...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (value) {
                      // キーボードフォーカスを外してからメッセージを送信
                      FocusScope.of(context).unfocus();
                      Future.delayed(const Duration(milliseconds: 50), () {
                        _sendMessage(value);
                      });
                    },
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () {
                    final text = _messageController.text;
                    if (text.trim().isNotEmpty) {
                      _sendMessage(text);
                    }
                  },
                  mini: true,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
