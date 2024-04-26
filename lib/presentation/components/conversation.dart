import 'package:flutter/material.dart';

import '../../data/domain/conversation.dart';

class CardConversation extends StatelessWidget {
  final Conversation conversation;

  const CardConversation({super.key, required this.conversation});

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

// 뒤로가기 아이콘 추가 (AppBar 오른쪽 배치)

// class ConversationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('대화 내용'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () => Navigator.pop(context), // 뒤로가기 기능 구현
//           ),
//         ],
//       ),
//       body: ListView( // 여러 CardConversation 위젯을 리스트로 표시
//         children: [
//           CardConversation(conversation: conversation1), // 대화 내용 1
//           CardConversation(conversation: conversation2), // 대화 내용 2
//           // ... (다른 대화 내용 추가)
//         ],
//       ),
//     );
//   }
// }
