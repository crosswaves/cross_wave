import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repository/remaining_chats_load.dart';

class RemainingChatsLoadImpl implements RemainingChatsLoad {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<int> getRemainingChats(String uid) async {
    // 오늘 날짜의 시작과 끝 계산
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // 사용자 프로필에서 remainingChats 가져오기
    DocumentSnapshot userProfile = await _firestore.collection('profiles').doc(uid).get();
    if (userProfile.exists) {
      // Map<String, dynamic> 타입으로 안전하게 캐스팅
      Map<String, dynamic>? data = userProfile.data() as Map<String, dynamic>?;
      int remainingChats = data?['remainingChats'] ?? 0;

      // 오늘의 메시지 가져오기
      QuerySnapshot querySnapshot = await _firestore
          .collectionGroup('conversations')
          .where('uid', isEqualTo: uid)
          .where('startTime', isEqualTo: today)
          .get();

      // isMe가 true인 메시지의 개수 세기
      int todayMessageCount = 0;
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        List<dynamic> messages = doc['messages'];
        for (var message in messages) {
          if (message['isMe'] == true) {
            todayMessageCount++;
          }
        }
      }

      // 남은 잔여 횟수 계산
      int updatedRemainingChats = remainingChats - todayMessageCount;

      // 프로필의 remainingChats 업데이트
      await _firestore.collection('profiles').doc(uid).update({
        'remainingChats': updatedRemainingChats,
      });
      return updatedRemainingChats;
    } else {
      // 프로필이 존재하지 않는다면 잔여횟수를 0으로 반환
      return 0;
    }
  }
}
