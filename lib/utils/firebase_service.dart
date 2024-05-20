import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speak_talk/utils/firebase_store.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/model/profile.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseStoreService _firebaseStoreService = FirebaseStoreService();

  // Firestore에서 사용자 존재 여부 확인 및 새 프로필 생성
  Future<User?> checkAndCreateUserProfile() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // 사용자가 로그인을 취소한 경우

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .get();

      if (!userData.exists) {
        // 새 사용자일 경우, 구글 정보를 사용하여 프로필 생성
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(user.uid)
            .set({
          'id': user.uid,
          'name': user.displayName ?? "Unnamed User",
          'email': user.email,
          'lastSignInTime': user.metadata.lastSignInTime,
          'joinDate': user.metadata.creationTime,
          'profilePicture': user.photoURL,
          'membershipLevel': '일반',
          'level': 'Iron',
          'weeklyProgress': 0,
          'dailyProgress': 0,
          'remainingChats': 5,
          'theme': ['life'],
        });
        return null; // 신규 프로필 생성 후 null 반환하여 IntroNameScreen으로 유도
      }
      return user; // 기존 사용자인 경우 user 반환
    } else {
      return null; // 사용자 정보가 null인 경우, 로그인 실패
    }
  }

  // 로그아웃 메서드
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Google 로그아웃
      await _auth.signOut(); // Firebase 로그아웃
      print("로그아웃 성공");
    } catch (e) {
      print("로그아웃 실패: $e");
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<DocumentSnapshot?> getUserData(User user) async {
    try {
      // Firestore에서 해당 사용자의 정보 가져오기
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userData;
    } catch (e) {
      print("사용자 정보 가져오기 실패: $e");
      return null;
    }
  }
}
