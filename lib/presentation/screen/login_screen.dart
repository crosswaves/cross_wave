import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/intro_name_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/firebase_service.dart';
import 'home_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    final _authService = FirebaseAuthService();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Colors.black,
              Colors.lightBlue,
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 75,
            ),
            const Image(
              image: AssetImage('assets/logo.png'),
            ),
            Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                color: Color(0xFFECE6CC),
                shape: BoxShape.circle,
              ),
              child: TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final isFirstLogin = prefs.getBool('isFirstLogin') ?? true;

                  // 구글 로그인 메서드
                  // if (isFirstLogin) {
                  User? user = await _authService.signInWithGoogle();
                  if (user != null) {
                    print('로그인 성공: ${user.displayName}님 환영합니다!;');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IntroNameScreen(),
                      ),
                    );
                  }

                  // 첫 로그인 시 NameSetScreen으로 이동
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const IntroNameScreen(),
                  //     ),
                  //   );
                  //   await prefs.setBool('isFirstLogin', false);
                  // } else {
                  //   // 두 번째 로그인 시 바로 HomeScreen으로 이동
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const HomeScreen(),
                  //     ),
                  //   );
                  // }
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Google 로그인',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Icon(
                      Icons.login,
                      size: 50,
                      color: Colors.deepPurpleAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
