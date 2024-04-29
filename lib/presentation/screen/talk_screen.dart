import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/home_screen.dart';

class TalkScreen extends StatefulWidget {
  const TalkScreen({super.key});

  @override
  State<TalkScreen> createState() => _TalkScreenState();
}

class _TalkScreenState extends State<TalkScreen> {
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
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/logo.png',
                                width: 40, height: 40),
                            const SizedBox(width: 10),
                            const Text('C.W.',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              '개발 진행은 어떻게 되고 있나요?',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('사용자',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            Image.asset('assets/user.jpg',
                                width: 40, height: 40),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: Colors.yellow[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('ㅈㅅ;;'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/logo.png',
                                width: 40, height: 40),
                            const SizedBox(width: 10),
                            const Text('C.W.',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'ㅋㅋㅋㅋㅋ',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('사용자',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            Image.asset('assets/user.jpg',
                                width: 40, height: 40),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: Colors.yellow[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('ㅋㅋㅋ'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/logo.png',
                                width: 40, height: 40),
                            const SizedBox(width: 10),
                            const Text('C.W.',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              '죽음',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('사용자',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            Image.asset('assets/user.jpg',
                                width: 40, height: 40),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: Colors.yellow[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('제발 자비를;;'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                        '통화종료',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
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
