import 'dart:async';

abstract class MessageCount {
  Future<List<int>> getMessageCount(String uid);
}
