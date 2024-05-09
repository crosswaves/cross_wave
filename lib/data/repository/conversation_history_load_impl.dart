import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/model/conversation_history.dart';
import '../../domain/repository/conversation_history_load.dart';

class ConversationHistoryLoadImpl implements ConversationHistoryLoad {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<ConversationHistory>> getConversationHistory(String uid) async {
    // 해당 사용자의 대화 목록을 가져오는 Firestore 쿼리
    final querySnapshot = await _firestore
        .collection('conversations')
        .where('uid', isEqualTo: uid)
        // .orderBy('startTime', descending: true) // startTime을 기준으로 내림차순 정렬
        .get();

    // 대화 목록을 변환하여 ConversationHistory 객체의 리스트로 반환
    return querySnapshot.docs
        .map((doc) => ConversationHistory.fromFirestore(doc))
        .toList();
  }
}
