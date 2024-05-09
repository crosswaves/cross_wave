import '../model/conversation_history.dart';

abstract class ConversationHistoryLoad {
  Future<List<ConversationHistory>> getConversationHistory(String uid);
}
