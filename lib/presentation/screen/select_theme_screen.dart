import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/components/select_theme_card.dart';
import 'package:flutter_speak_talk/presentation/screen/talk_screen.dart';

class SelectThemeScreen extends StatelessWidget {
  const SelectThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('주제 선택하기'),
        centerTitle: true,
        backgroundColor: const Color(0xFFC4E6F3),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              _themeTopText(),
              const SizedBox(height: 10),
              _gridItems(),
              _bottomButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _themeTopText() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Center(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    textAlign: TextAlign.center,
                    '관심있는 주제를\n 모두 선택해 주세요',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        // 기본 텍스트 스타일
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: '관심있는 주제를 \n'),
                        TextSpan(
                          text: '3가지', // 특별히 강조할 텍스트
                          style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' 이상 선택해 주세요. \n내게 꼭 맞는 코스를 추천해드릴게요!'),
                      ],
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

  Widget _gridItems() {
    return GridView(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 9,
        mainAxisSpacing: 9,
      ),
      children: const [
        SelectThemeItems(title: '커리어'),
        SelectThemeItems(title: '여행'),
        SelectThemeItems(title: '영화/음악'),
        SelectThemeItems(title: '친목'),
        SelectThemeItems(title: '문화'),
        SelectThemeItems(title: '연애'),
        SelectThemeItems(title: '쇼핑'),
        SelectThemeItems(title: '음식'),
        SelectThemeItems(title: '가족'),
      ],
    );
  }

  Widget _bottomButton(context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        clipBehavior: Clip.none,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D427F),
          minimumSize: const Size(300, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TalkScreen()));
        },
        child: const Text(
          '다음',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
