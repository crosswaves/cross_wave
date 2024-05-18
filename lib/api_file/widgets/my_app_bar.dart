import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/active_theme_provider.dart';
import 'theme_switch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('대화'),
      automaticallyImplyLeading: false, // 뒤로가기 버튼 없애기
      actions: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.live_help_outlined),
              onPressed: () {
                _showInputDialog(context);
              },
            ),
            Consumer(
              builder: (context, ref, child) => Icon(
                ref.watch(activeThemeProvider) == Themes.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            ),
            const SizedBox(width: 8),
            const ThemeSwitch(),
          ],
        )
      ],
    );
  }

  void _showInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String userInput = '';
        return AlertDialog(
          title: const Text("영작하고 싶은 한국어 문장을 입력하세요!"),
          content: TextField(
            onChanged: (value) {
              userInput = value;
            },
            decoration: const InputDecoration(hintText: "문장을 입력하세요"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
                _showOutputDialog(context, userInput); // 결과 출력
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  void _showOutputDialog(BuildContext context, String userInput) {
    // 여기서 영작된 문장으로 변환하는 로직을 추가할 수 있습니다.
    // 현재는 입력된 문장을 그대로 출력합니다.
    String translatedText = "입력된 문장: $userInput"; // 예제 결과 텍스트

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("결과"),
          content: Text(translatedText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: translatedText));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("텍스트가 클립보드에 복사되었습니다.")),
                );
              },
              child: const Text("복사"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: const Text("닫기"),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}