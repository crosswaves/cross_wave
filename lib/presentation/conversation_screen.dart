import 'package:flutter/material.dart';
import '../data/domain/model/conversation.dart';
import 'components/feedback_popup.dart';
import 'components/conversation_card.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = [
      const Conversation(
        username: 'Counterpart',
        message: "What's your name?",
        isMe: false,
      ),
      const Conversation(
        username: 'Me',
        message: 'Andrew Neiman, sir.',
        isMe: true,
      ),
      const Conversation(
        username: 'Counterpart',
        message: 'What year are you?',
        isMe: false,
      ),
      const Conversation(
        username: 'Me',
        message: "I'm a first-year, sir.",
        isMe: true,
      ),
      // Add more conversations as needed// Conversation 1 (Other person's message)
      const Conversation(
        username: 'Counterpart',
        message: 'You know who I am?',
        isMe: false,
      ),
      const Conversation(
        username: 'Me',
        message: 'Yes...',
        isMe: true,
      ),
      // Add more conversations as needed// Conversation 1 (Other person's message)
      const Conversation(
        username: 'Counterpart',
        message: "So you know I'm looking for players.",
        isMe: false,
      ),
      const Conversation(
        username: 'Me',
        message: 'Yes...',
        isMe: true,
      ),
      // Add more conversations as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('대화 내용'),
        actions: [
          IconButton(
              icon: const Icon(Icons.feedback_rounded),
              color: Colors.deepPurpleAccent,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const FeedbackPopup(),
                );
              }),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ConversationCard(conversation: conversation);
            },
          ),
        ],
      ),
    );
  }
}
