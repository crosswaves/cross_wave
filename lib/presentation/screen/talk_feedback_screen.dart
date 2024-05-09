import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'talk_history_screen.dart';

class TalkFeedbackScreen extends StatelessWidget {
  final String conversationId;

  const TalkFeedbackScreen({Key? key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('conversations')
              .doc(conversationId)
              .get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('대화 피드백');
            } else if (snapshot.hasError) {
              return Text('데이터 로드에 실패했습니다: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('대화 내역이 없습니다.');
            } else {
              final startTime = snapshot.data!.get('startTime') as Timestamp;
              final formattedStartTime =
              DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(startTime.toDate());
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('대화 피드백'),
                  Text(
                    formattedStartTime,
                    style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                  ),
                ],
              );
            }
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TalkHistoryScreen(conversationId: conversationId)),
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
                  '피드백 기능 추가 예정',
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
