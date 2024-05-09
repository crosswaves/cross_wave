import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/talk_history_screen.dart';

class TalkFeedbackScreen extends StatelessWidget {
  const TalkFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text('대화 피드백'),
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
              MaterialPageRoute(builder: (context) => const TalkHistoryScreen()),
            );
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.grey,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  '~~~~',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ), // Rest of your TalkFeedbackScreen content here
    );
  }
}