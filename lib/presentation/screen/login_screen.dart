import 'package:cloud_firestore/cloud_firestore.dart';
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
    final authService = FirebaseAuthService();

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
            const SizedBox(height: 75),
            const Image(image: AssetImage('assets/logo.png')),
            Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                color: Color(0xFFECE6CC),
                shape: BoxShape.circle,
              ),
              child: TextButton(
                onPressed: () async {
                  User? user = await authService.checkAndCreateUserProfile();
                  if (user != null) {
                    // 기존 사용자인 경우 HomeScreen으로 이동
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  } else {
                    // 신규 사용자 또는 로그인 취소/실패한 경우 IntroNameScreen으로 이동
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IntroNameScreen()));
                  }
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
                    SizedBox(height: 5),
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
