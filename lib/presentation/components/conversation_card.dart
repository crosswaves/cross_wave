import 'package:flutter/material.dart';
import '../../data/domain/model/conversation.dart';

class ConversationCard extends StatelessWidget {
  final Conversation conversation;

  const ConversationCard({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: conversation.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 메시지 내용 배경
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: conversation.isMe ? Colors.amber : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                conversation.isMe? const Icon(Icons.person) : const Icon(Icons.account_circle), // 상대방 아이콘
                const SizedBox(width: 8),
                Expanded( // 메시지 텍스트 영역 확장
                  child: Text(conversation.message),
                ),
              ],
            ),
          ),

          // 메시지 간격
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}