import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/model/ai_translate.dart';
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
              onPressed: () async {
                Navigator.of(context).pop(); // 팝업 닫기
                await _translateAndShowOutputDialog(context, userInput); // 번역 및 결과 출력
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _translateAndShowOutputDialog(BuildContext context, String userInput) async {
    AiTranslate aiTranslate = AiTranslate();
    String translatedText = await aiTranslate.getResponse(userInput);

    debugPrint('Translated Text: $translatedText'); // 디버깅 메시지 추가

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlertDialog(
          title: const Text("결과"),
          content: Text(translatedText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: translatedText));
                ScaffoldMessenger.maybeOf(Scaffold.of(context) as BuildContext)?.showSnackBar(
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
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
