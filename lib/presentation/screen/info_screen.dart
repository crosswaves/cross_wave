import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              // auth_utils 파일에 isFirstLogin 값을 true로 설정.
              //첫 번째 로그인 상태로
              await prefs.setBool('isFirstLogin', true);

              // 로그아웃 후에 로그아웃된거 메시지
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("로그아웃 되었습니다."),
                ),
              );

              // // 로그아웃 담에 로그인 페이지로
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.amber,
              minimumSize: const Size(75, 125),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
