import 'package:flutter/material.dart';
import './function.dart';

// メッセージ表示ウィジェット
class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            // 横並び
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //アイコン追加
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.green.shade100,
                child: const Icon(
                  Icons.person, size: 20,color: Colors.green
                  ),
              ),
              // メッセージ
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: message.isUser
                    ?Colors.blue.shade500
                    :Colors.grey.shade200,
                    borderRadius:
                    BorderRadius.circular(18),
                    // チャット タスク1 メッセージの背景色
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ),
              ),
              // チャット タスク2 ここにCircleAvatarを追加
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text(
              _formatTime(message.timestamp),
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
