import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationHistory {
  final String id;
  final DateTime startTime;
  final String duration;
  final String previewMessage;

  ConversationHistory({
    required this.id,
    required this.startTime,
    required this.duration,
    required this.previewMessage,
  });

  factory ConversationHistory.fromFirestore(DocumentSnapshot doc) {
    var messages = doc['messages'] as List<dynamic>;
    var firstMessage = messages.isNotEmpty ? messages[0]['message'] : '';

    return ConversationHistory(
      id: doc.id,
      startTime: (doc['startTime'] as Timestamp).toDate(),
      duration: doc['duration'],
      previewMessage: firstMessage,
    );
  }
}
