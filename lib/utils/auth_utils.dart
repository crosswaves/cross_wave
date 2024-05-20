import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  static Future<void> setLoginStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  static Future<bool> getLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setFirstLoginCompleted(bool isCompleted) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstLoginCompleted', isCompleted);
  }

  static Future<bool> getFirstLoginCompleted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('firstLoginCompleted') ?? false;
  }

  // 로그아웃 기능을 추가합니다.
  static Future<void> logout() async {
    // 로그인 상태를 false로 설정합니다.
    await setLoginStatus(false);
    // 필요한 경우, 다른 세션 정보도 여기서 초기화할 수 있습니다.
  }
}
