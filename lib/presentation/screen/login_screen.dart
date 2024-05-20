import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/intro_name_screen.dart';
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
            const SizedBox(height: 150),
            const Image(image: AssetImage('assets/logo.png')),
            const SizedBox(height: 50),
            Container(
              width: 250,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFECE6CC),
                shape: BoxShape.circle,
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  minimumSize: const Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Image(
                  image: AssetImage('assets/google.png'),
                  height: 24,
                ),
                label: const Text(
                  'Google 로그인',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () async {
                  User? user = await authService.checkAndCreateUserProfile();
                  if (user != null) {
                    // Existing user, navigate to HomeScreen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  } else {
                    // New user or login canceled/failed, navigate to IntroNameScreen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IntroNameScreen()));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
