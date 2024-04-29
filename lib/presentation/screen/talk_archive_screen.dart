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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: List.generate(
            20,
            (index) => const ConversationList(),
          ),
        ),
      ),
    );
  }
}
