import 'package:flutter/material.dart';
import '../screen/talk_history_screen.dart';

class ConversationList extends StatelessWidget {
  const ConversationList({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TalkHistoryScreen()),
        );
      },

      child: const Card(
        child: Column(
          children: [
            ListTile(
              title: Text('대화주제 : 일상'),
              subtitle: Text('?월 ??일 ??시 ??분'),
            ),
          ],
        ),
      ),
    );
  }
}