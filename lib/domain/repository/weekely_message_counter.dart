import 'dart:async';

abstract class WeeklyMessageCounter {
  Future<List<int>> getWeeklyMessageCount(String uid);
}
