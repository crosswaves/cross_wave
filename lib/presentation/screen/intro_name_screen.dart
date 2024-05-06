import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/data/domain/model/profile.dart';
import 'package:flutter_speak_talk/presentation/screen/intro_level_screen.dart';

import '../../utils/firebase_store.dart';

class IntroNameScreen extends StatefulWidget {
  const IntroNameScreen({super.key});

  @override
  State<IntroNameScreen> createState() => _IntroNameScreenState();
}

class _IntroNameScreenState extends State<IntroNameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(); // 이름을 입력받기 위한 컨트롤러
  final FirebaseStoreService _firebaseStore = FirebaseStoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                        '1/2',
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
                      'CrossWave가 어떤 이름으로\n불러드릴까요?',
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
                height: 100,
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
              const Spacer(),
              Visibility(
                visible: !_isKeyboardVisible,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(140, 140),
                    backgroundColor: const Color(0xFFECE6CC),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        User? user = _auth.currentUser;
                        if (user != null) {
                          await _firebaseStore.updateProfile(
                            Profile(
                              name: _nameController.text,
                              email: user.email,
                              joinDate: user.metadata.creationTime ?? DateTime.now(),
                              lastSignInTime: user.metadata.lastSignInTime ?? DateTime.now(),
                              membershipLevel: '일반',
                              level: 'Iron',
                              weeklyProgress: 0,
                              dailyProgress: 0,
                              remainingChats: 5,
                              profilePicture: user.photoURL ?? 'https://via.placeholder.com/150',
                            ),
                          );
                        } else {
                          throw Exception('No authenticated user found');
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('프로필 업데이트에 실패했습니다')));
                        print('Failed to update profile: $e');
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IntroLevelScreen(),
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 25,
                        color: Colors.deepPurpleAccent,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
