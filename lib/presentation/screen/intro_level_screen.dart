import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/home_screen.dart';

class IntroLevelScreen extends StatefulWidget {
  const IntroLevelScreen({super.key});

  @override
  State<IntroLevelScreen> createState() => _IntroLevelScreenState();
}

class _IntroLevelScreenState extends State<IntroLevelScreen> {
  bool isPressed0 = false;
  bool isPressed1 = false;
  bool isPressed2 = false;
  bool isPressed3 = false;

  void onClicked0() {
    setState(() {
      isPressed0 = !isPressed0;
    });
  }

  void onClicked1() {
    setState(() {
      isPressed1 = !isPressed1;
    });
  }

  void onClicked2() {
    setState(() {
      isPressed2 = !isPressed2;
    });
  }

  void onClicked3() {
    setState(() {
      isPressed3 = !isPressed3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
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
            const SizedBox(height: 40),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      '2/2',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  child: const Text(
                    '난이도 설정하기',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(300, 100),
                      maximumSize: const Size(300, 100),
                      backgroundColor:
                          isPressed0 ? Colors.amber : Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                    ),
                    onPressed: onClicked0,
                    child: const Text(
                      'Lv. 0\n영어단어 조금만 알아요',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 25), // 버튼 사이 간격
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(300, 100),
                      maximumSize: const Size(300, 100),
                      backgroundColor:
                          isPressed1 ? Colors.amber : Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                    ),
                    onPressed: onClicked1,
                    child: const Text(
                      'Lv. 1\n간단한 대화가 가능해요',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 25), // 버튼 사이 간격
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(300, 100),
                      maximumSize: const Size(300, 100),
                      backgroundColor:
                          isPressed2 ? Colors.amber : Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                    ),
                    onPressed: onClicked2,
                    child: const Text(
                      'Lv. 2\n일반적인 표현이 가능해요',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(300, 100),
                      maximumSize: const Size(300, 100),
                      backgroundColor:
                          isPressed3 ? Colors.amber : Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                    ),
                    onPressed: onClicked3,
                    child: const Text(
                      'Lv. 3\n현지인 수준이예요',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
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
                      '시작하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
