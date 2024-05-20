import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'pay_card_screen.dart';

// 멤버십 유형을 정의하는 Enum
enum MembershipType {
  free,
  premium,
  vip,
}

class InfoPayScreen extends StatefulWidget {
  const InfoPayScreen({super.key});

  @override
  State<InfoPayScreen> createState() => _InfoPayScreenState();
}

class _InfoPayScreenState extends State<InfoPayScreen> {
  MembershipType selectedMembershipType = MembershipType.free;

  Future<void> updateMembership(String userId, String newMembershipLevel, int remainingChats, int maxChats) async {
    try {
      await FirebaseFirestore.instance.collection('profiles').doc(userId).update({
        'membershipLevel': newMembershipLevel,
        'remainingChats': remainingChats,
        'maxChats': maxChats,
      });
    } catch (e) {
      // 에러 처리
      print('Failed to update membership: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 선택된 멤버십 유형에 따라 newMembershipLevel 및 remainingChats 설정
    String newMembershipLevel = '';
    int remainingChats = 0;
    int maxChats = 0;
    switch (selectedMembershipType) {
      case MembershipType.free:
        newMembershipLevel = '일반';
        remainingChats = 15;
        maxChats = 15;
        break;
      case MembershipType.premium:
        newMembershipLevel = '프리미엄';
        remainingChats = 100;
        maxChats = 100;
        break;
      case MembershipType.vip:
        newMembershipLevel = 'VIP';
        remainingChats = 1000;
        maxChats = 1000;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('요금제 설정'),
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
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.all(55),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '요금제 선택하기',
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 80),
                        maximumSize: const Size(300, 80),
                        backgroundColor:
                        selectedMembershipType == MembershipType.free
                            ? Colors.lightBlue
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                        shadowColor: Colors.black,
                        elevation: 10,
                      ),
                      onPressed: () async {
                        if (selectedMembershipType != MembershipType.free) {
                          setState(() {
                            selectedMembershipType = MembershipType.free;
                          });
                        } else {
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            String userId = user.uid;
                            await updateMembership(userId, newMembershipLevel, remainingChats, maxChats);
                          } else {
                            // 사용자가 인증되지 않은 경우 처리
                            print('User not logged in');
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 32,
                      ),
                      label: const Text(
                        'Free',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '일 대화횟수 최대 15건 제한',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 80),
                        maximumSize: const Size(300, 80),
                        backgroundColor:
                        selectedMembershipType == MembershipType.premium
                            ? Colors.lightBlue
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                        shadowColor: Colors.black,
                        elevation: 10,
                      ),
                      onPressed: () {
                        if (selectedMembershipType != MembershipType.premium) {
                          setState(() {
                            selectedMembershipType = MembershipType.premium;
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PayCardScreen(
                                  selectedMembershipType:
                                  selectedMembershipType),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 32,
                      ),
                      label: const Text(
                        'Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Column(
                      children: [
                        Text(
                          '일 대화횟수 100건 제공',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '대화 피드백 기능 추가 활성화',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 80),
                        maximumSize: const Size(300, 80),
                        backgroundColor:
                        selectedMembershipType == MembershipType.vip
                            ? Colors.lightBlue
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                        shadowColor: Colors.black,
                        elevation: 10,
                      ),
                      onPressed: () {
                        if (selectedMembershipType != MembershipType.vip) {
                          setState(() {
                            selectedMembershipType = MembershipType.vip;
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PayCardScreen(
                                  selectedMembershipType:
                                  selectedMembershipType),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.diamond,
                        color: Colors.white,
                        size: 32,
                      ),
                      label: const Text(
                        'VIP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Column(
                      children: [
                        Text(
                          '일 대화횟수 1000건 제공',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '대화 피드백 기능, 번역 기능 추가 활성화',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}