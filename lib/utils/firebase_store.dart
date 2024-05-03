import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/domain/model/profile.dart';

class FirebaseStoreService {
  FirebaseStoreService(this.userId);

  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<int> getProfiles() async {
  //   try {
  //     final DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('profiles')
  //         .doc(userId)
  //         .get();
  //
  //     final _userId = snapshot.get('userId');
  //     return _userId is int ? _userId : 0;
  //   } catch (e) {
  //     print('Error getting userId: $e');
  //     return 0;
  //   }
  // }
  //
  // Future<void> setProfiles(int userId) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('profiles')
  //         .doc(userId)
  //         .set({'userId': userId}, SetOptions(merge: true));
  //   } catch (e) {
  //     print('Error updating userId: $e');
  //   }
  // }

  // 사용자 프로필 저장
  // Future<void> createUserProfile() async {
  //   Profile newProfile = Profile(
  //     name: '아이유',
  //     profilePicture: 'https://img.tvreportcdn.de/cms-content/uploads/2023/10/06/becfe7e9-e863-453a-9a18-3ef1e4597b1f.jpg',
  //     membershipLevel: 'Silver',
  //     joinDate: DateTime.now(),
  //     level: 'Advanced',
  //     weeklyProgress: 40,
  //     dailyProgress: 10,
  //     int remainingChats: 5,

  //   );
  //
  //   await _firestore.collection('profiles').doc(userId).set(newProfile.toFirestore());
  // }
  //
  // // 사용자 프로필 불러오기
  // Future<void> getUserProfile() async {
  //   DocumentSnapshot doc = await _firestore.collection('profiles').doc(userId).get();
  //
  //   if (doc.exists) {
  //     Profile profile = Profile.fromFirestore(doc);
  //     print('Name: ${profile.name}');
  //     // 나머지 필드도 이와 같이 출력 가능
  //   } else {
  //     print('No data found!');
  //   }
  // }

  // 프로필 추가 혹은 업데이트 (set 사용 시 동일 ID에 대해 업데이트 가능)
  Future<void> addProfile(Profile profile, String userId) async {
    if (profile.name == null) {
      throw Exception('Name is required!');
    }
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc('userId') // 이제 모든 작업은 'userId' 문서에 적용됩니다.
        .set(profile.toJson());
  }

  // 특정 프로필 읽기
  Future<Profile> readProfile() async {
    var doc = await FirebaseFirestore.instance
        .collection('profiles')
        .doc('userId')
        .get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Profile(
        id: doc.id, // 문서의 ID를 Profile 객체의 id 필드에 저장
        name: data['name'] as String?, // as String?를 사용하여 null이 허용되는 필드 처리
        profilePicture: data['profilePicture'] as String?, // null 허용
        membershipLevel: data['membershipLevel'] as String, // null이 허용되지 않음, 기본값이 필요할 수 있음
        joinDate: DateTime.parse(data['joinDate'] as String), // DateTime으로 변환
        level: data['level'] as String, // null이 허용되지 않음
        weeklyProgress: data['weeklyProgress'] as int, // int 형식 필드
        dailyProgress: data['dailyProgress'] as int, // int 형식 필드
        remainingChats: data['remainingChats'] as int, // int 형식 필드
      );
    } else {
      throw Exception('Profile not found!');
    }
    // if (doc.exists) {
    //   return Profile.fromJson(doc.data() as Map<String, dynamic>);
    // } else {
    //   throw Exception('Profile not found!');
    // }
  }

  // 프로필 업데이트
  Future<void> updateProfile(Profile profile) async {
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc('userId') // 문서 ID를 'userId'로 지정
        .update(profile.toJson());
  }

  // 프로필 삭제
  Future<void> deleteProfile() async {
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc('userId')
        .delete();
  }

  void createNewProfile() {
    Profile newProfile = Profile(
      name: '아이유이유',
      profilePicture: 'https://images.emarteveryday.co.kr/images/app/webapps/evd_web2/share/SKU/mall/63/03/8801073210363_1.png',
      membershipLevel: '일반회원',
      joinDate: DateTime.now(),
      level: 'beginner',
      weeklyProgress: 70,
      dailyProgress: 10,
      remainingChats: 3,
    );

    String userId = 'uniqueUserId';  // 이 사용자의 고유 ID
    addProfile(newProfile, userId).then((_) {
      print('Profile added successfully!');
    }).catchError((error) {
      print('Failed to add profile: $error');
    });
  }
}
