import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../components/feedback_popup.dart';
import 'talk_archive_screen.dart';

class TalkHistoryScreen extends StatelessWidget {
  final String conversationId;

  const TalkHistoryScreen({super.key, required this.conversationId});

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
              return const Text('대화 내역');
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
                  const Text('대화 내역'),
                  Text(
                    formattedStartTime,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.blueGrey),
                  ),
                ],
              );
            }
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TalkArchiveScreen()),
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
                builder: (context) =>
                    FeedbackPopup(conversationId: conversationId),
              );
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
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
            final Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            final List<dynamic> messages = data['messages'];
            if (messages.isEmpty) {
              return const Center(child: Text('대화 내역이 없습니다.'));
            }

            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessage(message);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final isMe = message['isMe'] ?? false;
    final text = message['message'] ?? '';

    return Align(
      alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isMe ? Colors.blueAccent : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe
                      ? const Radius.circular(16)
                      : const Radius.circular(0),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(16),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: isMe ? null : 0,
              right: isMe ? 0 : null,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isMe ? Colors.blueAccent : Colors.grey[300],
                  borderRadius: isMe
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(16),
                        )
                      : const BorderRadius.only(
                          topRight: Radius.circular(16),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
