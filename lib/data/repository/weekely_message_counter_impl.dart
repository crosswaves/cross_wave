import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repository/weekely_message_counter.dart';

class WeeklyMessageCounterImpl implements WeeklyMessageCounter {
  final CollectionReference _conversationCollection = FirebaseFirestore.instance.collection('conversations');

  @override
  Future<List<int>> getWeeklyMessageCount(String uid) async {
    try {
      DateTime now = DateTime.now();
      DateTime thisMonday = now.subtract(Duration(days: now.weekday - 1)); // 이번 주의 첫째 날 (월요일)
      DateTime nextMonday = thisMonday.add(const Duration(days: 7)); // 다음 주의 월요일

      QuerySnapshot querySnapshot = await _conversationCollection
          .where('uid', isEqualTo: uid)
          .orderBy('startTime', descending: true) // startTime을 기준으로 내림차순 정렬
          .where('startTime', isGreaterThanOrEqualTo: thisMonday)
          .where('startTime', isLessThan: nextMonday)
          .get();

      List<int> messageCounts = List.filled(7, 0);

      querySnapshot.docs.forEach((conversationDoc) {
        List<dynamic>? messages = (conversationDoc.data() as Map<String, dynamic>?)?['messages'] as List<dynamic>?;

        messages?.forEach((message) {
          if (message['isMe'] == true) {
            Timestamp timestamp = message['timestamp']; // Timestamp 객체로 받음
            int dayOfWeek = timestamp.toDate().weekday % 7; // 월요일부터 0으로 시작하도록 조정
            messageCounts[dayOfWeek]++;
          }
        });
      });

      return messageCounts;
    } catch (e) {
      throw Exception('Failed to get weekly message count: $e');
    }
  }
}