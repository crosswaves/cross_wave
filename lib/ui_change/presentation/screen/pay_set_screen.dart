import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/home_screen.dart';
import 'package:flutter_speak_talk/presentation/screen/pay_card_screen.dart';

class PaySetScreen extends StatefulWidget {
  const PaySetScreen({super.key});

  @override
  State<PaySetScreen> createState() => _PaySetScreenState();
}

class _PaySetScreenState extends State<PaySetScreen> {
  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.all(75),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '요금제 설정하기',
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
