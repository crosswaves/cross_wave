// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class FirebaseStoreService {
//
//   FirebaseStoreService(this.userId);
//
//   final String userId;
//
//   Future<int> getUserId() async {
//     try {
//       final DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
//
//       final _userId = snapshot.get('userId');
//       return _userId is int ? _userId : 0;
//     } catch (e) {
//       print('Error getting userId: $e');
//       return 0;
//     }
//   }
//
//   Future<void> setUserId(int userId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .set({'userId': userId}, SetOptions(merge: true));
//     } catch (e) {
//       print('Error updating userId: $e');
//     }
//   }
// }