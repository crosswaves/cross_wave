import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repository/weekely_message_counter.dart';

class WeeklyMessageCounterImpl implements WeeklyMessageCounter {
  final CollectionReference _conversationCollection = FirebaseFirestore.instance.collection('conversations');

  @override
  Future<List<int>> getWeeklyMessageCount(String uid) async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // 이번 주의 첫째 날 (월요일)
      DateTime endOfWeek = startOfWeek.add(Duration(days: 7)); // 이번 주의 마지막 날 (다음 주의 월요일)

      QuerySnapshot querySnapshot = await _conversationCollection
          .where('uid', isEqualTo: uid)
          .where('startTime', isGreaterThanOrEqualTo: startOfWeek)
          .where('startTime', isLessThan: endOfWeek)
          .get();
      
      List<int> messageCounts = List.filled(7, 0);

      querySnapshot.docs.forEach((conversationDoc) {
        List<dynamic>? messages = (conversationDoc.data() as Map<String, dynamic>?)?['messages'];

        messages?.forEach((message) {
          if (message['isMe'] == true) {
            DateTime timestamp = DateTime.parse(message['timestamp']);
            int dayOfWeek = timestamp.weekday - 1; // 일요일부터 0으로 시작하도록 조정
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
