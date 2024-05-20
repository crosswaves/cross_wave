import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'info_pay_screen.dart';

class PayCardScreen extends StatelessWidget {
  final MembershipType selectedMembershipType;

  const PayCardScreen({super.key, required this.selectedMembershipType});

  Future<void> updateMembership(String userId, String newMembershipLevel,
      int remainingChats, int maxChats) async {
    try {
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userId)
          .update({
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
        title: const Text('결제 화면'),
        backgroundColor: const Color(0xFF91A7E8),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('카드 정보 입력',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '카드 번호',
                hintText: '1234 5678 9012 3456',
              ),
              keyboardType: TextInputType.number,
              maxLength: 19,
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '만료 날짜',
                hintText: 'MM/YY',
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CVV',
                hintText: '123',
              ),
              keyboardType: TextInputType.number,
              maxLength: 3,
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    String userId = user.uid;
                    // 결제 로직을 구현하거나 결제 확인 다이얼로그 표시
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('결제 확인'),
                        content: const Text('결제를 진행하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('취소'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('확인'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await updateMembership(userId, newMembershipLevel,
                                  remainingChats, maxChats);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    // 사용자가 인증되지 않은 경우 처리
                    print('User not logged in');
                  }
                },
                child: const Text('결제하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}