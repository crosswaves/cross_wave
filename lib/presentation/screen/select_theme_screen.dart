import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // 현재 화면이 SelectThemeScreen 화면인지 확인
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      _showExitConfirmationDialog();
      return true;
    }
    return false; // 다른 화면에서는 기본 동작을 수행 (뒤로 가기)
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('앱 종료'),
        content: const Text('앱을 종료하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('아니요'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              SystemNavigator.pop();
            },
            child: const Text('예'),
          ),
        ],
      ),
    );
  }

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

  final Map<String, String> themeTranslation = {
    '커리어': 'Career',
    '여행': 'Travel',
    '영화/음악': 'Movie/Music',
    '가족': 'Family',
    '문화': 'Culture',
    '연애': 'Love',
    '쇼핑': 'Shopping',
    '음식': 'Food',
    '운동': 'Exercise',
  };

  Color? backgroundColor = const Color(0xFFA3C4D6); // 각 타일의 배경색

  void _toggleTheme(String theme) {
    setState(() {
      if (_selectedThemes.contains(theme)) {
        _selectedThemes.remove(theme);
      } else {
        if (_selectedThemes.length < 3) {
          _selectedThemes.add(theme);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('3개까지 선택이 가능합니다.'),
            ),
          );
        }
      }
    });
  }

  void _saveTheme() {
    final FirebaseStoreService firebaseStore = FirebaseStoreService();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final translatedThemes =
          _selectedThemes.map((e) => themeTranslation[e]).toList();
      firebaseStore.updateProfileField(user.uid, {'theme': translatedThemes});
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const TalkScreen()));
    } else {
      throw Exception('No user currently found');
    }
  }

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
                color: isSelected
                    ? const Color(0xFFA3C4D6)
                    : const Color(0xFF0D427F),
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
        // backgroundColor: const Color(0xFFC4E6F3),
      ),
      body: Container(
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
                    ),
                  ),
                  Text(
                    '1가지 이상',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.yellow
                          : Colors.deepOrangeAccent,
                    ),
                  ),
                  const Text('선택해 주세요. ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  const Text(
                    '내가 원하는 주제로 대화할 수 있어요!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
          ),
        ),
      ),
    );
  }
}
