import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/home_screen.dart';
import 'package:flutter_speak_talk/presentation/screen/pay_card_screen.dart';

class InfoPayScreen extends StatefulWidget {
  const InfoPayScreen({super.key});

  @override
  State<InfoPayScreen> createState() => _InfoPayScreenState();
}

class _InfoPayScreenState extends State<InfoPayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('요금제 설정'),
        centerTitle: true,
        backgroundColor: Color(0xFFC4E6F3),
      ),
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
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.all(55),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '요금제 선택하기',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(300, 150),
                      maximumSize: const Size(300, 150),
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PayCardScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      '프리미엄',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 25), // 버튼 사이 간격
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(300, 150),
                      maximumSize: const Size(300, 150),
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PayCardScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      '프리미엄 프로',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 25), // 버튼 사이 간격
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      '프리티어 시작하기',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
