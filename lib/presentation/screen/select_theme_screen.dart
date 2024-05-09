import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/talk_screen.dart';

import '../../utils/firebase_store.dart';

class SelectThemeScreen extends StatefulWidget {
  final String title;
  final void Function(String) onSelected;

  const SelectThemeScreen(
      {super.key, required this.title, required this.onSelected});

  @override
  State<SelectThemeScreen> createState() => _SelectThemeScreenState();
}

class _SelectThemeScreenState extends State<SelectThemeScreen> {
  final List<String> _selectedThemes = [];
  final themeList = [
    '커리어',
    '여행',
    '영화/음악',
    '가족',
    '문화',
    '연애',
    '쇼핑',
    '음식',
    '운동',
  ];
  Color? backgroundColor = const Color(0xFFA3C4D6); // 각 타일의 배경색

  void _toggleTheme(String theme) {
    setState(() {
      if (_selectedThemes.contains(theme)) {
        _selectedThemes.remove(theme);
      } else {
        _selectedThemes.add(theme);
      }
    });
  }

  void _saveTheme() {
    final FirebaseStoreService _firebaseStore = FirebaseStoreService();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _firebaseStore.updateProfileField(user.uid, {'theme': _selectedThemes});
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const TalkScreen()));
    } else {
      throw Exception('No user currently found');
    }
  }

  // void _toggleBackgroundColor() {
  //   setState(() {
  //     // 배경색이 현재 설정된 색과 다른 색으로 토글
  //     backgroundColor = backgroundColor == const Color(0xFF0D427F)
  //         ? Color(0xFFA3C4D6)
  //         : const Color(0xFF0D427F);
  //   });
  // }

  // 각 타일의 제목
  Widget _themeCardWidget(String theme, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleTheme(theme),
      child: Card(
        elevation: 2.0, // 카드의 그림자 깊이
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            alignment: Alignment.center,
            color:
                isSelected ? const Color(0xFF0D427F) : const Color(0xFFA3C4D6),
            child: Text(
              theme,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: isSelected ? Color(0xFFA3C4D6) : Color(0xFF0D427F),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 9,
        mainAxisSpacing: 9,
      ),
      itemCount: themeList.length,
      itemBuilder: (BuildContext context, index) {
        final theme = themeList[index];
        final isSelected = _selectedThemes.contains(theme);
        return _themeCardWidget(theme, isSelected);
      },
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
          _saveTheme();
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
