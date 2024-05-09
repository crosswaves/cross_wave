import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speak_talk/utils/firebase_store.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/domain/model/profile.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseStoreService _firebaseStoreService = FirebaseStoreService();

  // 이메일 패스워드 로그인
  // Future<User?> signInWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return userCredential.user;
  //   } on FirebaseAuthException catch (e) {
  //     print("Sign in error: ${e.message}");
  //     return null;
  //   }
  // }
  //
  // Future<User?> signUpWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return userCredential.user;
  //   } on FirebaseAuthException catch (e) {
  //     print("Sign up error: ${e.message}");
  //     return null;
  //   }
  // }

  // 구글 이메일 로그인
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null; // 사용자가 로그인을 취소한 경우

      // google 인증 세부 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase에 로그인하기 위한 자격 증명 생성
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에 사용자 로그인
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential != null) {
        // 사용자 정보가 null이 아닌 경우에만 Firestore에 사용자 정보 저장
        await _firebaseStoreService.addProfile(Profile(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName,
          email: userCredential.user!.email,
          lastSignInTime: userCredential.user!.metadata.lastSignInTime,
          joinDate: userCredential.user!.metadata.creationTime,
          profilePicture: userCredential.user!.photoURL,
          membershipLevel: 'Standard',
          level: 'Iron',
          weeklyProgress: 0,
          dailyProgress: 0,
          remainingChats: 5,
          theme: ['life'],
        ));
        return userCredential.user; // 로그인된 사용자 정보 반환
      } else {
        return null; // 사용자 정보가 null인 경우 null 반환
      }
    } on Exception catch (e) {
      print('Exception during Google Sign-In: $e');
      return null;
    }
    // 사용자 정보가 null이 아닌 경우에만 Firestore에 사용자 정보 저장
    // await addUserData(userCredential.user!);
    // return userCredential.user; // 로그인된 사용자 정보 반환
    //     } else {
    //       return null; // 사용자 정보가 null인 경우 null 반환
    //     }
    //   } on Exception catch (e)
    //   {
    //     print('exception->$e');
    //     return null;
    //   }
    // }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Google 로그아웃
      await _auth.signOut(); // Firebase 로그아웃
      print("로그아웃 성공");
    } catch (e) {
      print("로그아웃 실패: $e");
    }
  }

  // Firestore에 사용자 정보 추가하는 함수
  // Future<void> addUserData(User user) async {
  //   try {
  //     final UserMetadata metadata =
  //         user.metadata; // Firebase Authentication의 사용자 메타데이터 가져오기
  //     // Firestore에 사용자 정보 users 컬렉션 내 userId 별 고유정보 저장
  //     await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
  //       'userId': user.uid,
  //       'email': user.email,
  //       'displayName': user.displayName,
  //       'photoUrl': user.photoURL,
  //       'creationTime': metadata.creationTime, // 가입일
  //       'lastSignInTime': metadata.lastSignInTime, // 마지막 접속일
  //     });
  //     print('사용자 정보 추가 성공');
  //   } catch (e) {
  //     print("사용자 정보 추가 실패: $e");
  //   }
  // }

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
