import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/model/profile.dart';

class FirebaseStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 프로필 추가 혹은 업데이트 (set 사용 시 동일 ID에 대해 업데이트 가능)
  Future<void> addProfile(Profile profile) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('profiles')
          .doc(user.uid)
          .set(profile.toJson());
    } else {
      throw Exception('No user logged in!');
    }

    if (profile.name == null) {
      throw Exception('Name is required!');
    }
    await _firestore
        .collection('users')
        .doc(user.uid) // 이제 모든 작업은 'userId' 문서에 적용됩니다.
        .set(profile.toJson());
  }

  // 특정 프로필 읽기
  Future<Profile> readProfile() async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user currently found');
    }

    var doc = await _firestore.collection('profiles').doc(user.uid).get();

    if (!doc.exists) {
      throw Exception('Profile for the current user does not exist!');
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Profile(
      id: doc.id,
      // 문서의 ID를 Profile 객체의 id 필드에 저장
      name: data['name'] as String?,
      // as String?를 사용하여 null이 허용되는 필드 처리
      profilePicture: data['profilePicture'] as String?,
      email: data['email'] as String?,
      lastSignInTime: data['lastSignInTime'] != null
          ? DateTime.parse(data['lastSignInTime'] as String)
          : null,
      membershipLevel: data['membershipLevel'] as String,
      joinDate: DateTime.parse(data['joinDate'] as String),
      level: data['level'] as String,
      weeklyProgress: data['weeklyProgress'] as int,
      dailyProgress: data['dailyProgress'] as int,
      remainingChats: data['remainingChats'] as int,
      theme: _parseThemeList(data['theme']), // int 형식 필드
    );
  }

  // Firebase에서 theme 정보 불러오는 메서드
  Future<String> readTheme() async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user currently found');
    }

    var doc = await _firestore.collection('profiles').doc(user.uid).get();

    if (!doc.exists) {
      throw Exception('Profile for the current user does not exist!');
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String theme = data['theme'] as String;
    return theme;
  }

  List<String> _parseThemeList(dynamic themeField) {
    if (themeField is List) {
      return List<String>.from(themeField.map((item) => item.toString()));
    }
    return []; // Return an empty list if the field is missing or is not a list
  }

// 프로필 업데이트
  Future<void> updateProfile(Profile profile) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('profiles')
          .doc(user.uid) // 문서 ID를 'userId'로 지정
          .update(profile.toJson());
    } else {
      throw Exception('No authenticated user found');
    }
  }

  // 특정 필드만 업데이트하는 메서드
  Future<void> updateProfileField(
      String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('profiles').doc(userId).update(updates);
    } on FirebaseException catch (e) {
      // Firebase 특정 예외 처리
      print('Firebase error updating profile field: ${e.message}');
      throw Exception('Firebase error: ${e.code} - ${e.message}');
    } catch (e) {
      // 다른 모든 예외 처리
      print('General error updating profile field: $e');
      throw Exception('Error updating profile field: $e');
    }
  }

  Future<void> updateProfileName(String userId, String newName) async {
    DocumentReference profileRef =
        _firestore.collection('profiles').doc(userId);

    // 현재 프로필을 읽어와서 이름이 설정되어 있는지 확인
    DocumentSnapshot snapshot = await profileRef.get();
    var data = snapshot.data()
        as Map<String, dynamic>?; // 데이터를 Map<String, dynamic>으로 캐스팅

    if (data != null &&
        data.containsKey('name') &&
        data['name'] != null &&
        data['name'].isNotEmpty) {
      // 이름이 이미 설정되어 있으면 업데이트 하지 않음
      print('Name already set. No update performed.');
    } else {
      // 이름이 설정되어 있지 않으면 새 이름으로 업데이트
      profileRef.update({'name': newName});
    }
  }

// 프로필 삭제
  Future<void> deleteProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('profiles').doc(user.uid).delete();
    } else {
      throw Exception('No authenticated user found');
    }
  }
}
