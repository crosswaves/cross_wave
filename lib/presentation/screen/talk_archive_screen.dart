import 'package:flutter/material.dart';
import '../components/conversation_list.dart';

class TalkArchiveScreen extends StatelessWidget {
  const TalkArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이전 대화 목록'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Navigate back to HomeScreen
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: List.generate(
            20, // Generate 5 instances of CardConversation, change the number as needed
            (index) => const ConversationList(),
          ),
        ),
      ),
    );
  }
}
