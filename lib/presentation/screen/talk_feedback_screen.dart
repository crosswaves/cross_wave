import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../domain/model/ai_feedback.dart';

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
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('conversations')
              .doc(conversationId)
              .get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('데이터 로드에 실패했습니다: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('대화 내역이 없습니다.'));
            } else {
              final List<dynamic> messages = snapshot.data!.get('messages');
              if (messages.isEmpty) {
                return const Center(child: Text('대화 내역이 없습니다.'));
              }

              return FutureBuilder<String>(
                future: _getFeedback(messages),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('피드백을 가져오는 중에 오류가 발생했습니다: ${snapshot.error}'));
                  } else {
                    return Center(
                      child: Text(
                        snapshot.data ?? '피드백이 없습니다.',
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<String> _getFeedback(List<dynamic> messages) async {
    // 대화 내용을 하나의 문자열로 결합
    final conversation = messages.map((message) => message['message'].toString()).join(' ');

    // AI 피드백 요청
    final aiFeedback = AiFeedback();
    final feedback = await aiFeedback.getResponse(conversation);

    return feedback;
  }
}