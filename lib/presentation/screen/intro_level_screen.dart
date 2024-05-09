import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/home_screen.dart';

import '../../data/domain/model/profile.dart';
import '../../utils/firebase_store.dart';

class IntroLevelScreen extends StatefulWidget {
  final String name;

  const IntroLevelScreen({super.key, required this.name});

  @override
  State<IntroLevelScreen> createState() => _IntroLevelScreenState();
}

class _IntroLevelScreenState extends State<IntroLevelScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStoreService _firebaseStore = FirebaseStoreService();


  String selectedLevel = '';
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

  void updateLevel(String level) async {
    setState(() {
      selectedLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
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
          key: _formKey,
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
                        selectedLevel == 'Iron' ? Colors.amber : Colors
                            .lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                      ),
                      onPressed: () => updateLevel('Iron'),
                      child: const Text(
                        'Iron\n영어단어 조금만 알아요',
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
                        selectedLevel == 'Bronze' ? Colors.amber : Colors
                            .lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                      ),
                      onPressed: () => updateLevel('Bronze'),
                      child: const Text(
                        'Bronze\n간단한 대화가 가능해요',
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
                        selectedLevel == 'Silver' ? Colors.amber : Colors
                            .lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                      ),
                      onPressed: () => updateLevel('Silver'),
                      child: const Text(
                        'Silver\n일반적인 표현이 가능해요',
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
                        selectedLevel == 'Gold' ? Colors.amber : Colors
                            .lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                      ),
                      onPressed: () => updateLevel('Gold'),
                      child: const Text(
                        'Gold\n현지인 수준이예요',
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
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          try {
                            User? user = _auth.currentUser;
                            if (user != null) {
                              await _firebaseStore.updateProfile(
                                  Profile(
                                      name: widget.name,
                                      email: user.email,
                                      joinDate: user.metadata.creationTime ?? DateTime.now(),
                                      lastSignInTime: user.metadata.lastSignInTime ?? DateTime.now(),
                                      profilePicture: user.photoURL ?? 'https://via.placeholder.com/150',
                                      membershipLevel: '일반',
                                      level: selectedLevel,
                                      weeklyProgress: 0,
                                      dailyProgress: 0,
                                      remainingChats: 5,
                                      theme: [''],
                                  ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('프로필 업데이트에 실패했습니다.'),
                              ),
                            );
                            print('Failed to update profile: $e');
                          }
                        }
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
      ),
    );
  }
}
