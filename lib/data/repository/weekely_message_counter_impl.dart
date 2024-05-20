import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repository/weekely_message_counter.dart';

class WeeklyMessageCounterImpl implements WeeklyMessageCounter {
  final CollectionReference _conversationCollection =
      FirebaseFirestore.instance.collection('conversations');

  @override
  Future<List<int>> getWeeklyMessageCount(String uid) async {
    try {
      DateTime now = DateTime.now();
      DateTime thisMonday = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: now.weekday - 1));
      DateTime nextMonday = thisMonday.add(const Duration(days: 7));

      QuerySnapshot querySnapshot = await _conversationCollection
          .where('uid', isEqualTo: uid)
          .orderBy('startTime', descending: true)
          .where('startTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(thisMonday))
          .where('startTime', isLessThan: Timestamp.fromDate(nextMonday))
          .get();

      List<int> messageCounts = List.filled(7, 0);

      querySnapshot.docs.forEach((conversationDoc) {
        print('conversationDoc data: ${conversationDoc.data()}');
        List<dynamic>? messages = (conversationDoc.data()
            as Map<String, dynamic>?)?['messages'] as List<dynamic>?;

        messages?.forEach((message) {
          print('message: $message');
          if (message['isMe'] == true) {
            Timestamp timestamp = message['timestamp'];
            int dayOfWeek = timestamp.toDate().weekday % 7;
            messageCounts[dayOfWeek]++;
          }
        });
      });

      return messageCounts;
    } catch (e) {
      print('Failed to get weekly message count: $e');
      throw Exception('Failed to get weekly message count: $e');
    }
  }
}
