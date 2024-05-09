import 'package:flutter/material.dart';
import '../../data/domain/model/conversation.dart';
import '../components/conversation_card.dart';
import '../components/feedback_popup.dart';
import 'talk_archive_screen.dart';

class TalkHistoryScreen extends StatelessWidget {
  const TalkHistoryScreen({super.key});

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
        title: const Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text('대화 내역'),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                '2024년 4월 29일 14시 45분',
                style: TextStyle(fontSize: 14,color: Colors.blueGrey),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TalkArchiveScreen()),
            );
          },
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conversation = conversations[index];
            return ConversationCard(conversation: conversation);
          },
        ),
      ),
    );
  }
}
