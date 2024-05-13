import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repository/weekely_message_counter.dart';

class WeeklyMessageCounterImpl implements WeeklyMessageCounter {
  final CollectionReference _conversationCollection = FirebaseFirestore.instance.collection('conversations');

  @override
  Future<List<int>> getWeeklyMessageCount(String uid) async {
    try {
      // 현재 날짜의 시작 시간 (12:00 AM)
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // 이번 주의 첫째 날 (월요일)
      DateTime endOfWeek = startOfWeek.add(Duration(days: 7)); // 이번 주의 마지막 날 (다음 주의 월요일)

      // 파이어베이스에서 해당 uid를 가진 모든 문서 가져오기
      QuerySnapshot querySnapshot = await _conversationCollection.where('uid', isEqualTo: uid).get();

      // 요일별 발화 개수를 저장할 리스트 초기화
      List<int> messageCounts = List.filled(7, 0);

      // 모든 문서에 대해 처리
      querySnapshot.docs.forEach((conversationDoc) {
        List<dynamic>? messages = (conversationDoc.data() as Map<String, dynamic>?)?['messages'];

        // 메시지 확인 및 발화 개수 계산
        messages?.forEach((message) {
          DateTime? timestamp = message['timestamp'] != null ? DateTime.parse(message['timestamp']) : null;
          if (timestamp != null && timestamp.isAfter(startOfWeek) && timestamp.isBefore(endOfWeek)) {
            int dayOfWeek = (timestamp.weekday + 5) % 7; // 시작 요일을 월요일로 설정하기 위해 보정
            if (message['isMe'] == true) {
              // isMe가 true이면 발화인 것으로 간주하여 누적
              messageCounts[dayOfWeek]++;
            }
          }
        });
      });

      return messageCounts;
    } catch (e) {
      throw Exception('Failed to get message count by week: $e');
    }
  }
}
