import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Sign in error: ${e.message}");
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Sign up error: ${e.message}");
      return null;
    }
  }

  // Future<void> signOut() asnyc {
  //   await _auth.signOut();
  // }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null; // 사용자가 로그인을 취소한 경우

      // google 인증 세부 정보 가져오기
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Firebase에 로그인하기 위한 자격 증명 생성
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Firebase에 사용자 로그인
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user; // 로그인된 사용자 정보 반환
    } on Exception catch (e) {
      print('exception->$e');
      return null;
    }
  }
}
