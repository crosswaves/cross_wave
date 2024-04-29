import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/profile_set_screen.dart';

class NameSetScreen extends StatefulWidget {
  const NameSetScreen({super.key});

  @override
  State<NameSetScreen> createState() => _NameSetScreenState();
}

class _NameSetScreenState extends State<NameSetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(); // 이름을 입력받기 위한 컨트롤러
  bool get _isKeyboardVisible {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

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
        child: Form(
          key: _formKey, // Form의 상태를 관리하기 위한 key
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
                            '이름 설정하기',
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
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: '이름을 입력하세요',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ' '; // 여기서는 오류 메시지를 반환하지 않습니다.
                    }
                    return null; // 입력이 유효할 경우 null 반환
                  },
                ),
              ),
              const SizedBox(
                height: 140,
              ),
              Visibility(
                visible: !_isKeyboardVisible,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(240, 240),
                    backgroundColor: const Color(0xFFECE6CC),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileSetScreen(),
                        ),
                      );
                    } else {
                      // 입력값이 유효하지 않은 경우 팝업 메시지를 표시합니다.
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('알림'),
                          content: const Text('이름을 입력해주세요'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('확인'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '다음 설정',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 50,
                        color: Colors.deepPurpleAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
