import 'package:flutter/material.dart';
import 'package:cross_wave/presentation/components/conversation_list.dart';

class ArchiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이전 대화'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {}, // onPressed: () => Navigator.pop(context),
          ),
        ],

      ),
      body: ListView(
        children: List.generate(
          20, // Generate 5 instances of CardConversation, change the number as needed
              (index) => const ConversationList(),
        ),
      ),
    );
  }
}